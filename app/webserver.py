from flask import Flask, render_template_string, request, send_file, jsonify, url_for, make_response
import subprocess
import os
import uuid
import tempfile
from google.cloud import speech
import logging
import sys

app = Flask(__name__)

# At the top of your file, configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Also ensure Flask logs are visible
app.logger.setLevel(logging.DEBUG)


app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB limit

HELLO_PAGE = """
<!DOCTYPE html>
<html>
<head>
    <title>Hello</title>
</head>
<body>
    <h1>tale->tekst->lilypond</h1>
    <button id="recordButton">Hold inne knappen for å generere lyd og partitur</button>
    <p id="status"></p>
    <div id="pdfDisplay">
    {% if pdf_exists %}
        <embed src="{{ url_for('get_pdf') }}?cache={{ cache_buster }}" type="application/pdf" width="600" height="800" />
    {% else %}
        <p>Ingen pdf generert ennå.</p>
    {% endif %}
    </div>
<script>
let chunks = [];
let mediaRecorder = null;
let isRecording = false;
let stream = null;

function getSupportedMimeType() {
    const types = [
        'audio/webm;codecs=opus',
        'audio/webm',
        'audio/mp4',
        'audio/wav'
    ];
    
    for (let type of types) {
        if (MediaRecorder.isTypeSupported(type)) {
            return type;
        }
    }
    return ''; // fallback to default
}

function startRecording() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        document.getElementById("status").innerText = "Manglende mikrofontilgang, ingen støtte for getUserMedia eller usikker tilknytting.";
        return;
    }
    if (isRecording) return;
    isRecording = true;
    document.getElementById("status").innerText = "Recording...";
    
    navigator.mediaDevices.getUserMedia({ audio: true })
        .then(s => {
            stream = s;
            const mimeType = getSupportedMimeType();
            
            if (mimeType) {
                mediaRecorder = new MediaRecorder(stream, { mimeType: mimeType });
            } else {
                mediaRecorder = new MediaRecorder(stream);
            }

            chunks = [];
            mediaRecorder.ondataavailable = e => {
                if (e.data.size > 0) {
                    chunks.push(e.data);
                }
            };
            
            mediaRecorder.onstop = e => {
                // Use the same mimeType as the MediaRecorder
                const recordedMimeType = mediaRecorder.mimeType || 'audio/webm';
                const blob = new Blob(chunks, { type: recordedMimeType });
                
                let formData = new FormData();
                formData.append('audio', blob, 'input-speech.webm'); // Use .webm extension
                
                document.getElementById("status").innerText = "Processing...";
                
                fetch('/process', { method: 'POST', body: formData })
                    .then(res => {
                        if (!res.ok) {
                            throw new Error(`HTTP error! status: ${res.status}`);
                        }
                        return res.json();
                    })
                    .then(data => {
                        if (data.success) {
                            document.getElementById("status").innerText = "Done!";
                            document.getElementById("pdfDisplay").innerHTML = '';
                            setTimeout(() => {
                                document.getElementById("pdfDisplay").innerHTML = 
                                    '<embed src="/ly-display.pdf?cache=' + Date.now() + 
                                    '" type="application/pdf" width="600" height="800" />';
                            }, 100);
                        } else {
                            document.getElementById("status").innerText = "Error: " + data.error;
                        }
                    })
                    .catch(err => {
                        console.error('Fetch error:', err);
                        document.getElementById("status").innerText = "Upload failed: " + err.message;
                    });
                
                if (stream) {
                    stream.getTracks().forEach(track => track.stop());
                }
                isRecording = false;
            };
            
            mediaRecorder.onerror = e => {
                console.error('MediaRecorder error:', e);
                document.getElementById("status").innerText = "Recording error: " + e.error;
                isRecording = false;
            };
            
            mediaRecorder.start();
        })
        .catch(err => {
            console.error('getUserMedia error:', err);
            document.getElementById("status").innerText = "Microphone access denied or error: " + err.message;
            isRecording = false;
        });
}

function stopRecording() {
    if (!isRecording) return;
    isRecording = false;
    if (mediaRecorder && mediaRecorder.state === "recording") {
        mediaRecorder.stop();
    }
}

// Robust event handling for mouse and touch
const btn = document.getElementById("recordButton");

btn.addEventListener('mousedown', (e) => { e.preventDefault(); startRecording(); });
document.addEventListener('mouseup', (e) => { stopRecording(); }); // Listen on whole doc
btn.addEventListener('mouseleave', (e) => { stopRecording(); });

btn.addEventListener('touchstart', (e) => { e.preventDefault(); startRecording(); }, {passive: false});
document.addEventListener('touchend', (e) => { stopRecording(); }, {passive: false});
btn.addEventListener('touchcancel', (e) => { stopRecording(); });

</script>
</body>
</html>
"""

subprocess.run(
    ["bash", "flush-web.sh"])

def convert_to_wav(input_file, output_file):
    """Convert audio file to WAV format using ffmpeg"""
    try:
        subprocess.run([
            'ffmpeg', '-y', '-i', input_file, 
            '-acodec', 'pcm_s16le', '-ar', '48000', '-ac', '1',
            output_file
        ], check=True, capture_output=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"FFmpeg conversion error: {e}")
        return False
    
### kopiert fra googleclouds eksempelbruk
def transcribe_audio(audio_file_path):
    client = speech.SpeechClient()
    print("Received audio file size:", os.path.getsize("input-speech.wav"))
    with open(audio_file_path, "rb") as audio_file:
        content = audio_file.read()

    audio = speech.RecognitionAudio(content=content)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=48000,
        language_code="no-NO",
    )

    response = client.recognize(config=config, audio=audio)
    transcript = ""
    for result in response.results:
        transcript += result.alternatives[0].transcript
    return transcript

@app.route("/", methods=["GET"])
def hello():
    pdf_exists = os.path.exists("ly-display.pdf")
    cache_buster = uuid.uuid4().hex
    return render_template_string(HELLO_PAGE, pdf_exists=pdf_exists, cache_buster=cache_buster)

@app.route("/process", methods=["POST"])
def process_audio():
    print("begynner prossessering")
    
    audio = request.files.get("audio")
    if audio is None:
        return jsonify({"success": False, "error": "Ingen lyd tilgjengelig."}), 400

    # Save and convert audio
    temp_audio = "temp_audio.webm"
    audio.save(temp_audio)
    
    input_wav = "input-speech.wav"
    print("begynner å konvertere lydformat")
    if not convert_to_wav(temp_audio, input_wav):
        return jsonify({"success": False, "error": "Audio conversion failed"}), 400
    
    if os.path.exists(temp_audio):
        os.remove(temp_audio)

    print(f"Lagde lydfil med størrelse på: {os.path.getsize(input_wav)} bytes")

    try:
        # Transcribe
        transcript = transcribe_audio(input_wav)
        print("Transkriberte følgende teksta:")
        print(transcript)
        
        if not transcript:
            return jsonify({"success": False, "error": "Ingen transkripsjon lagd"}), 400
        
        with open("input.txt", "w", encoding="utf-8") as f:
            f.write(transcript)
            f.flush()
            os.fsync(f.fileno())
        
        print(f"Lagde tekstfil med størrelse på: {os.path.getsize('input.txt')} bytes")
        
    except Exception as e:
        print(f"Transcription error: {e}")
        return jsonify({"success": False, "error": f"Transcription failed: {str(e)}"}), 500
    
    # Get list of all PDF files before running script
    import glob
    pdfs_before = {}
    for pdf in glob.glob("*.pdf"):
        pdfs_before[pdf] = {
            'mtime': os.path.getmtime(pdf),
            'size': os.path.getsize(pdf)
        }
    print(f"PDFs before script: {list(pdfs_before.keys())}")
    
    # Delete the target PDF to force regeneration
    if os.path.exists("ly-display.pdf"):
        print("Deleting old ly-display.pdf")
        os.remove("ly-display.pdf")
    
    # Run the script
    try:
        print("Running run-web.sh...")
        print("Script content preview:")
        with open("run-web.sh", "r") as f:
            lines = f.readlines()
            # Look for lilypond commands
            for i, line in enumerate(lines):
                if 'lilypond' in line.lower() or 'pdf' in line.lower() or 'ly-display' in line:
                    print(f"Line {i}: {line.strip()}")
        
        result = subprocess.run(
            ["bash", "-x", "run-web.sh"],  # -x for debug output
            check=True,
            cwd=os.getcwd(),
            capture_output=True,
            text=True,
            timeout=60
        )
        print("Script output (last 1000 chars):", result.stdout[-1000:] if len(result.stdout) > 1000 else result.stdout)
        print("Script debug output (last 1000 chars):", result.stderr[-1000:] if len(result.stderr) > 1000 else result.stderr)
            
    except subprocess.CalledProcessError as e:
        print(f"run-web.sh failed with return code {e.returncode}")
        return jsonify({"success": False, "error": f"run-web.sh failed: {str(e)}"}), 500
    except Exception as e:
        print(f"Unexpected error running run-web.sh: {e}")
        return jsonify({"success": False, "error": f"Script execution error: {str(e)}"}), 500

    import time
    time.sleep(1)  # Give more time for file operations
    
    # Check what PDFs exist now
    pdfs_after = {}
    for pdf in glob.glob("*.pdf"):
        pdfs_after[pdf] = {
            'mtime': os.path.getmtime(pdf),
            'size': os.path.getsize(pdf)
        }
    print(f"PDFs after script: {list(pdfs_after.keys())}")
    
    # Check what changed
    for pdf_name in pdfs_after:
        if pdf_name not in pdfs_before:
            print(f"NEW PDF created: {pdf_name}")
        elif pdfs_after[pdf_name]['mtime'] > pdfs_before[pdf_name]['mtime']:
            print(f"UPDATED PDF: {pdf_name}")
        else:
            print(f"UNCHANGED PDF: {pdf_name}")
    
    # Try different PDF names that might have been created
    possible_pdf_names = [
        "ly-display.pdf",
        "display.pdf", 
        "main.pdf",
        "main-midi.pdf",
        "lily-run-scheme-web.pdf",
        transcript.replace(" ", "-").lower() + ".pdf",  # Maybe it uses the transcript as name?
        "output.pdf"
    ]
    
    pdf_found = None
    for pdf_name in possible_pdf_names:
        if os.path.exists(pdf_name):
            print(f"Found PDF: {pdf_name} (size: {os.path.getsize(pdf_name)})")
            if pdf_name != "ly-display.pdf":
                # Copy it to ly-display.pdf
                print(f"Copying {pdf_name} to ly-display.pdf")
                import shutil
                shutil.copy2(pdf_name, "ly-display.pdf")
                pdf_found = "ly-display.pdf"
                break
            else:
                pdf_found = pdf_name
                break
    
    if pdf_found and os.path.getsize(pdf_found) > 0:
        return jsonify({"success": True, "transcript": transcript})
    
    # If still no PDF, let's check what lilypond files were processed
    print("\nChecking .ly files that might have been processed:")
    for ly_file in glob.glob("*.ly"):
        stat = os.stat(ly_file)
        print(f"{ly_file}: size={stat.st_size}, modified={time.ctime(stat.st_mtime)}")
    
    # Last resort: run lilypond directly
    print("\nAttempting to run lilypond directly...")
    for ly_file in ["main.ly", "lily-run-scheme-web.ly", "main-midi.ly"]:
        if os.path.exists(ly_file):
            try:
                print(f"Running lilypond on {ly_file}")
                lily_result = subprocess.run(
                    ["lilypond", "--pdf", "-o", "ly-display", ly_file],
                    capture_output=True,
                    text=True,
                    timeout=30
                )
                print(f"Lilypond stdout: {lily_result.stdout[:500]}")
                if lily_result.stderr:
                    print(f"Lilypond stderr: {lily_result.stderr[:500]}")
                
                if os.path.exists("ly-display.pdf"):
                    print("Successfully created ly-display.pdf with lilypond")
                    return jsonify({"success": True, "transcript": transcript})
                    
            except Exception as e:
                print(f"Failed to run lilypond on {ly_file}: {e}")
    
    return jsonify({
        "success": False, 
        "error": "PDF was not created", 
        "lydtranskripsjon": transcript,
        "pdfs_found": list(pdfs_after.keys())
    }), 500


@app.route("/ly-display.pdf")
def get_pdf():
    if os.path.exists("ly-display.pdf"):
        response = make_response(send_file("ly-display.pdf"))
        response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        return response
    return "Fant ikke pdf", 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
