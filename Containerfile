# Containerfile for Markdown to PDF conversion
# Based on the GitHub Actions workflow build-pdfs.yml
# Using Debian instead of Ubuntu - Debian has native Chromium (not snap)

FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Skip Puppeteer's bundled Chromium - we'll use system Chromium instead
# This fixes ARM64/Apple Silicon compatibility issues
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Install system dependencies including native Chromium
# Debian provides real Chromium packages (not snap wrappers like Ubuntu)
RUN apt-get update && \
    apt-get install -y \
        nodejs \
        npm \
        curl \
        python3 \
        python3-pip \
        ca-certificates \
        fontconfig \
        fonts-liberation \
        fonts-noto-color-emoji \
        fonts-noto-core \
        fonts-noto-ui-core \
        chromium \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libc6 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libexpat1 \
        libfontconfig1 \
        libgbm1 \
        libgcc-s1 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libstdc++6 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        lsb-release \
        wget \
        xdg-utils \
        procps \
        && \
    rm -rf /var/lib/apt/lists/* && \
    fc-cache -f -v

# Install md-to-pdf globally (Chromium download is skipped via env var above)
RUN npm install -g md-to-pdf

# Install pypdf for PDF bookmarks
# Use --break-system-packages flag for newer Python versions with externally-managed-environment
RUN pip3 install --break-system-packages pypdf

# Create working directory and config directory
WORKDIR /workspace
RUN mkdir -p /app/config

# Copy configuration files to /app/config (won't be overwritten by volume mounts)
COPY pdf-styles.css /app/config/pdf-styles.css
COPY .md-to-pdf.json /app/config/.md-to-pdf.json
COPY mermaid-init.js /app/config/mermaid-init.js
COPY add_pdf_bookmarks.py /app/add_pdf_bookmarks.py

# Make scripts executable
RUN chmod +x /app/add_pdf_bookmarks.py

# Create entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

