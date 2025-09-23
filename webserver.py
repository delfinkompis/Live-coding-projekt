from flask import Flask, render_template_string, request, send_file, jsonify, url_for
import subprocess
import os
import uuid
import tempfile


app = Flask(__name__)

HELLO_PAGE = """
<!DOCTYPE html>
<html>
<head>
    <title>Hello</title>
</head>
<body>
    <h1>hello world</h1>
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

function startRecording() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        document.getElementById("status").innerText = "Manglende mikrofontilgang, ingen støtte for getUserMedia eller usikker side.";
        return;
    }
    if (isRecording) return; // Prevent double start
    isRecording = true;
    document.getElementById("status").innerText = "Recording...";
    navigator.mediaDevices.getUserMedia({ audio: true })
        .then(s => {
            stream = s;
            mediaRecorder = new MediaRecorder(stream);
            chunks = [];
            mediaRecorder.ondataavailable = e => {
                if (e.data.size > 0) {
                    chunks.push(e.data);
                }
            };
            mediaRecorder.onstop = e => {
                const blob = new Blob(chunks, { type: 'audio/wav' });
                let formData = new FormData();
                formData.append('audio', blob, 'input-speech.mp3');
                document.getElementById("status").innerText = "Processing...";
                fetch('/process', { method: 'POST', body: formData })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            document.getElementById("status").innerText = "Done!";
                            document.getElementById("pdfDisplay").innerHTML = '<embed src="/ly-display.pdf?cache=' + Math.random() + '" type="application/pdf" width="600" height="800" />';
                        } else {
                            document.getElementById("status").innerText = "Error: " + data.error;
                        }
                    })
                    .catch(err => {
                        document.getElementById("status").innerText = "Upload failed.";
                    });
                if (stream) {
                    stream.getTracks().forEach(track => track.stop());
                }
                isRecording = false;
            };
            mediaRecorder.start();
        });
}

function stopRecording() {
    if (!isRecording) return; // Don’t stop if not recording
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

@app.route("/", methods=["GET"])
def hello():
    pdf_exists = os.path.exists("ly-display.pdf")
    cache_buster = uuid.uuid4().hex
    return render_template_string(HELLO_PAGE, pdf_exists=pdf_exists, cache_buster=cache_buster)

@app.route("/process", methods=["POST"])
def process_audio():
    audio = request.files.get("audio")
    if audio is None:
        return jsonify({"success": False, "error": "No audio file uploaded."}), 400
    input_wav = "input-speech.mp3"
    audio.save(input_wav)

    # Call run-web.sh
    try:
        result = subprocess.run(
            ["bash", "run-web.sh"],
            check=True
        )
        
    except subprocess.CalledProcessError as e:
        return jsonify({"success": False, "error": str(e)}), 500

    # Check if ly-display.pdf was created
    if os.path.exists("ly-display.pdf"):
        return jsonify({"success": True})
    else:
        return jsonify({"success": False, "error": "ly-display.pdf not found"}), 500

@app.route("/ly-display.pdf")
def get_pdf():
    if os.path.exists("ly-display.pdf"):
        return send_file("ly-display.pdf")
    return "PDF not found", 404

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
