FROM python:3.11-slim

#ADD https://gitlab.com/lilypond/lilypond/-/releases/v2.25.28/downloads/lilypond-2.25.28-darwin-x86_64.tar.gz ./
#RUN tar -xf lilypond-2.25.28-darwin-x86_64.tar.gz

# Install system dependencies
RUN apt-get update && apt-get install -y \
    procps \
    coreutils \
    sox \
    libsox-fmt-all \
    bc \
    ripgrep \
    findutils \
    parallel \
    jq \
    perl \
    ffmpeg \
    locales \
    guile-3.0 \
    csound \
    alsa-utils \
    wget \ 
    && sed -i '/nb_NO.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen nb_NO.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# bruker lilypondversjon 2.25.28 på grunn av raskere cairo-prosessering av partitur
RUN LILY_VERSION="2.25.28" \
    && wget "https://gitlab.com/lilypond/lilypond/-/releases/v2.25.28/downloads/lilypond-2.25.28-linux-x86_64.tar.gz" \
    && tar -xzf "lilypond-${LILY_VERSION}-linux-x86_64.tar.gz" \
    && mv "lilypond-${LILY_VERSION}" /opt/lilypond \
    && ln -s /opt/lilypond/bin/lilypond /usr/local/bin/lilypond \
    && rm "lilypond-${LILY_VERSION}-linux-x86_64.tar.gz"



ENV LANG=nb_NO.UTF-8
ENV LANGUAGE=nb_NO:nb
ENV LC_ALL=nb_NO.UTF-8

WORKDIR /app

COPY /app .

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN ./fetch-all-synonyms-web.sh > synonyms.txt

EXPOSE 8080

CMD ["python", "webserver.py"]

#CMD ["lilypond", "--loglevel=DEBUG", "-dlog-file=-", "lily-run-scheme-web.ly"]
