from flask import Flask, render_template_string, request, send_file, jsonify, url_for, make_response
import subprocess
import os
import uuid
import tempfile
from google.cloud import speech
import logging
import sys

app = Flask(__name__)

# Flaskelogging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Flaskeloggingnivå
app.logger.setLevel(logging.DEBUG)

app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # forsikre meg om at flask håndterer større filer

HELLO_PAGE = """
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>lily-text-to-speech-demo</title>
<link rel="stylesheet" href="https://cdn.simplecss.org/simple.css">
<style>
.responsive {
  width: 100%;
  height: auto;
}
button.aktiv,
button.aktiv:hover {
background-color: #898EA4;
}

</style>
</head>
<body>
    <h1>tale->tekst->lilypond</h1>
    <button id="recordButton">Hold inne knappen for å generere lyd og partitur</button>
    <p id="status"></p>
<figure>
  <figcaption></figcaption>
{% if audio_exists %}
<audio controls src="{{ url_for('get_sound') }}?cache={{ cache_buster }}"></audio>
{% else %}
<p>Ingen lyd generert ennå.</p>
{% endif %}
</figure>
    <div id="svgDisplay">
    {% if svg_exists %}
        <embed src="{{ url_for('get_svg') }}?cache={{ cache_buster }}" type="image/svg+xml" class="responsive" width="596" height="842" />
    {% else %}
        <p>Ingen svg generert ennå.</p>
    {% endif %}
    </div>
<div id="eksempeltekst">
<p>Eksempeltekst:</p>
<p>Eksempeltekst (hentet fra wikipedia):</p>
<p>Ål er en katadrom fisk i ålefamilien med slangelignende kropp og glatt, tykk hud. Den gyter i saltvann (Sargassohavet) og vokser opp i ferskvann. Arten forekommer i fersk- og brakkvann over hele Europa og Nord-Afrika</p>
</div>
<footer>
<p>Sida er laga med stilmall fra simple-css og ordboksdata fra språkrådet</p>
<a href="https://github.com/delfinkompis/Live-coding-projekt/">github-lenke til prosjektet</a>
</footer>
<script>
let chunks = [];
let mediaRecorder = null;
let isRecording = false;
let stream = null;

function getSupportedMimeType() {
// støttefunksjon i tilfelle nettleseren ikke støtter webm.
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
    return ''; // fallback
}

function startRecording() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        document.getElementById("status").innerText = "Manglende mikrofontilgang, ingen støtte for getUserMedia eller usikker tilknytting.";
        return;
    }
    if (isRecording) return;
    isRecording = true;
    document.getElementById("status").innerText = "Spiller inn...";
    
    navigator.mediaDevices.getUserMedia({ audio: true })
        .then(s => {
// boilerplate fra standardeksempel på js-innspilling fra nettet
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
                // Bruk mediainnspilleren som støttes
                const recordedMimeType = mediaRecorder.mimeType || 'audio/webm';
                const blob = new Blob(chunks, { type: recordedMimeType });
                
                let formData = new FormData();
                formData.append('audio', blob, 'input-speech.webm'); // bruk webm siden det er vanlig på webben
                
                document.getElementById("status").innerText = "Behandler...";

// Latterlig mye errorhandling - skal tas bort når jeg får muligheita
                fetch('/process', { method: 'POST', body: formData })
                    .then(res => {
                        if (!res.ok) {
                            throw new Error(`Prøv på nytt. Fant sannsynligvis ikke tekstinnehold i lydinnspillinga`);
                        }
                        return res.json();
                    })
                    .then(data => {
                        if (data.success) {
                            document.getElementById("status").innerText = "Ferdig!";
                            // Oppdater både svg og lyd
                            document.getElementById("svgDisplay").innerHTML = '';
                            const audioContainer = document.querySelector('figure');
                            audioContainer.innerHTML = '<figcaption>Lytt på output:</figcaption>';
                            
                            setTimeout(() => {
                                // Oppdater SVG hvis lyd ikke funker
                                document.getElementById("svgDisplay").innerHTML = 
                                    '<embed src="/ly-display.svg?cache=' + Date.now() + 
                                    '" type="image/svg+xml" width="600" height="800" />';
                                // Oppdater lyd hvis svg ikke funker
                                audioContainer.innerHTML = 
                                    '<figcaption>Lytt på output:</figcaption>' +
                                    '<audio controls src="/output.wav?cache=' + Date.now() + '"></audio>';
                            }, 100);
                        } else {
                            document.getElementById("status").innerText = "Error: " + data.error;
                        }
                    })
                    .catch(err => {
                        console.error('Fetch error:', err);
                        document.getElementById("status").innerText = "Opplasting misslykka: " + err.message;
                    });
                
                if (stream) {
                    stream.getTracks().forEach(track => track.stop());
                }
                isRecording = false;
            };
            
            mediaRecorder.onerror = e => {
                console.error('MediaRecorder error:', e);
                document.getElementById("status").innerText = "Innspillingserror: " + e.error;
                isRecording = false;
            };
            
            mediaRecorder.start();
        })
        .catch(err => {
            console.error('getUserMedia error:', err);
            document.getElementById("status").innerText = "Mikrofon utilgjengelig  eller anna error: " + err.message;
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

const btn = document.getElementById("recordButton");
let activeElement = null;

btn.addEventListener('mousedown', (e) => { e.preventDefault(); startRecording(); activeElement = e.target;
 activeElement.classList.add('aktiv'); });

document.addEventListener('mouseup', (e) => { stopRecording(); activeElement.classList.remove('aktiv'); activeElement = null; }); 

btn.addEventListener('touchstart', (e) => { e.preventDefault(); startRecording(); activeElement = e.target; activeElement.classList.add('aktiv'); }, {passive: false});

document.addEventListener('touchend', (e) => { stopRecording(); activeElement.classList.remove('aktiv'); activeElement = null; }, {passive: false});


</script>
</body>
</html>
"""

subprocess.run(
    ["bash", "flush-web.sh"])

def convert_to_wav(input_file, output_file):
    """Konverter lyd til wav med ffmpeg"""

    try:
        subprocess.run([
            'ffmpeg', '-y', '-i', input_file, 
            '-acodec', 'pcm_s16le', '-ar', '48000', '-ac', '1',
            output_file
        ], check=True, capture_output=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"FFmpeg klarte ikke konvertere: {e}")
        return False

### kopiert fra googleclouds eksempelbruk
def transcribe_audio(audio_file_path):
    client = speech.SpeechClient()
    print("Størrelse på lydfil:", os.path.getsize("input-speech.wav"))
    with open(audio_file_path, "rb") as audio_file:
        content = audio_file.read()

    audio = speech.RecognitionAudio(content=content)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=48000,
        language_code="no-NO",
        enable_word_time_offsets=True, 
    )

    transcript = []
    word_timestamps = []

    response = client.recognize(config=config, audio=audio)

    for result in response.results:
        transcript.append(result.alternatives[0].transcript)
        for word_info in result.alternatives[0].words:
            word_timestamps.append(str(word_info.start_time))
    return " ".join(transcript), " ".join(word_timestamps)


@app.route("/", methods=["GET"])
def hello():
    subprocess.run(
        ["bash", "flush-web.sh"])
    svg_exists = os.path.exists("ly-display.svg")
    audio_exists = os.path.exists("output.wav")
    cache_buster = uuid.uuid4().hex
    return render_template_string(HELLO_PAGE, svg_exists=svg_exists, audio_exists=audio_exists, cache_buster=cache_buster)

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
        return jsonify({"success": False, "error": "Klarte ikke konvertere lyd"}), 400

    if os.path.exists(temp_audio):
        os.remove(temp_audio)

    print(f"Lagde wav-lydfil med størrelse på: {os.path.getsize(input_wav)} bytes")

    try:
        # Transcribe
        transcript, timestamps = transcribe_audio(input_wav)
        print("Transkriberte følgende teksta:")
        print(transcript)

        print("Fikk disse tidskodene:")
        print(timestamps)

        if not transcript:
            return jsonify({"success": False, "error": "Ingen transkripsjon lagd"}), 400

        if not timestamps:
            return jsonify({"success": False, "error": "Ingen tidskoder laga"}), 400

        with open("input.txt", "w", encoding="utf-8") as f:
            f.write(transcript)
            f.flush()
            os.fsync(f.fileno())

        with open("timestamps.txt", "w", encoding="utf-8") as f:
            f.write(timestamps)
            f.flush()
            os.fsync(f.fileno())            

        print(f"Lagde tekstfil med størrelse på: {os.path.getsize('input.txt')} bytes")

        print(f"Lagde tidskodefil med størrelse på: {os.path.getsize('timestamps.txt')} bytes")

    except Exception as e:
        print(f"Transcription error: {e}")
        return jsonify({"success": False, "error": f"Transkripsjonen mislykka: {str(e)}"}), 500

    # liste opp filer før og etter funksjonen pga errorhåndtering
    import glob
    svgs_before = {}
    for svg in glob.glob("*.svg"):
        svgs_before[svg] = {
            'mtime': os.path.getmtime(svg),
            'size': os.path.getsize(svg)
        }
        print(f"svgfiler før funksjonen: {list(svgs_before.keys())}")

    audios_before = {}
    for audio_file in glob.glob("*.wav") + glob.glob("*.mp3") + glob.glob("*.ogg"):
        if audio_file != "input-speech.wav":  # Don't include our input file
            audios_before[audio_file] = {
                'mtime': os.path.getmtime(audio_file),
                'size': os.path.getsize(audio_file)
            }
    print(f"Lydfiler før skript: {list(audios_before.keys())}")

    # Delete the target files to force regeneration
    if os.path.exists("ly-display.svg"):
        print("Sletter gammel ly-display.svg")
        os.remove("ly-display.svg")

    if os.path.exists("output.wav"):
        print("Sletter gammel output.wav")
        os.remove("output.wav")

    try:
        print("Kjører run-web.sh...")

        result = subprocess.run(
            ["bash", "run-web.sh"],  #bruk -x-flagget for debug
            check=True,
            cwd=os.getcwd(),
            capture_output=True,
            text=True,
            timeout=60
        )
        print("Siste 10000 tegn fra sh skript:", result.stdout[-10000:] if len(result.stdout) > 10000 else result.stdout)
        print("Siste 10000 tegn fra sh error:", result.stderr[-10000:] if len(result.stderr) > 10000 else result.stderr)

    except subprocess.CalledProcessError as e:
        print(f"run-web.sh mislykka med kode {e.returncode}")
        return jsonify({"success": False, "error": f"run-web.sh mislykka: {str(e)}"}), 500
    except Exception as e:
        print(f"Uventa error i run-web.sh: {e}")
        return jsonify({"success": False, "error": f"Skript avslutta med error: {str(e)}"}), 500

    import time
    time.sleep(1)  # vent på filkopieringa

    # list opp svgs etter funksjonene
    svgs_after = {}
    for svg in glob.glob("*.svg"):
        svgs_after[svg] = {
            'mtime': os.path.getmtime(svg),
            'size': os.path.getsize(svg)
        }
    print(f"svg etter å ha kjørt sh: {list(svgs_after.keys())}")

    # list opp lydfiler etter funksjonene
    audios_after = {}
    for audio_file in glob.glob("*.wav") + glob.glob("*.mp3") + glob.glob("*.ogg"):
        if audio_file != "input-speech.wav":  
            audios_after[audio_file] = {
                'mtime': os.path.getmtime(audio_file),
                'size': os.path.getsize(audio_file)
            }
    print(f"Lydfiler etter å ha kjørt sh: {list(audios_after.keys())}")


    possible_svg_names = [
        "ly-display.svg"
    ]

    possible_audio_names = [
        "output.wav"
    ]

    svg_found = None
    audio_found = None

    # Massevis av errorhåndtering (slett dette)
    for svg_name in possible_svg_names:
         if os.path.exists(svg_name):
             print(f"Fant svg: {svg_name} (size: {os.path.getsize(svg_name)})")
             if svg_name != "ly-display.svg":
                 # Copy it to ly-display.svg
                 print(f"Kopierer {svg_name} til ly-display.svg")
                 import shutil
                 shutil.copy2(svg_name, "ly-display.svg")
                 svg_found = "ly-display.svg"
                 break
             else:
                 svg_found = svg_name
                 break

    # Håndter lydfiler
    for audio_name in possible_audio_names:
        if os.path.exists(audio_name):
            print(f"Fant lydfil: {audio_name} (size: {os.path.getsize(audio_name)})")
            if audio_name != "output.wav":
                # Copy it to output.wav
                print(f"Kopierer {audio_name} til output.wav")
                import shutil
                shutil.copy2(audio_name, "output.wav")
                audio_found = "output.wav"
                break
            else:
                audio_found = audio_name
                break

    # Sjekk etter andre relevante filer
    if not audio_found:
        for audio_file in audios_after:
            if audio_file not in audios_before:
                print(f"Fant ny lydfil: {audio_file} (size: {os.path.getsize(audio_file)})")
                import shutil
                shutil.copy2(audio_file, "output.wav")
                audio_found = "output.wav"
                break

    # If no specific SVG found, look for any new SVG files
    if not svg_found:
        for svg_file in svgs_after:
            if svg_file not in svgs_before:
                print(f"Fant ny svgfil: {svg_file} (size: {os.path.getsize(svg_file)})")
                import shutil
                shutil.copy2(svg_file, "ly-display.svg")
                svg_found = "ly-display.svg"
                break

    success = False
    if svg_found and os.path.getsize(svg_found) > 0:
        print(f"SVG funnet: {svg_found}")
        success = True
    else:
        print("Ingen gyldig svg funnet")

    if audio_found and os.path.getsize(audio_found) > 0:
        print(f"Lyd generert: {audio_found}")
        success = True
    else:
        print("Warning: ingen lydfil funnet")

    if success:
        return jsonify({"success": True, "transkripsjon": transcript})
    else:
        return jsonify({"success": False, "error": "Verken svg eller lydfil blei vellykka generert"}), 500


@app.route("/ly-display.svg")
def get_svg():
    if os.path.exists("ly-display.svg"):
        response = make_response(send_file("ly-display.svg"))
        response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        response.headers['Content-Type'] = 'image/svg+xml'
        return response
    return "Fant ikke svg", 404

@app.route("/output.wav")
def get_sound():
    if os.path.exists("output.wav"):
        response = make_response(send_file("output.wav", mimetype='audio/wav'))
        response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '0'
        return response
    return "Fant ikke lyd", 404


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
