# syntax=docker/dockerfile:1
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DENO_INSTALL=/usr/local

WORKDIR /app

# FFmpeg is used for media processing; Deno is used by yt-dlp to solve
# JavaScript challenges from supported sites.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl ffmpeg unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://deno.land/install.sh | sh

ENV PATH="/usr/local/bin:${PATH}"

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY bot.py channel_monitor.py channels.example.json ./

WORKDIR /app/data
CMD ["python", "-u", "/app/bot.py"]
