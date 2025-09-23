FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    procps \
    coreutils \
    sox \
    libsox-fmt-all \
    lilypond \
    bc \
    ripgrep \
    findutils \
    parallel \
    jq \
    perl \
    ffmpeg \
    csound \
    alsa-utils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy repo code
COPY . .

# Install Python requirements (if needed)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "webserver.py"]
