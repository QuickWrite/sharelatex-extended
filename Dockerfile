FROM sharelatex/sharelatex:latest
# using the official image as a base

LABEL \
  org.opencontainers.image.title="Overleaf with full TeX Live" \
  org.opencontainers.image.source="https://github.com/quickwrite/sharelatex-extended" \
  org.opencontainers.image.licenses="MIT"

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    && pip3 install --no-cache-dir --break-system-packages Pygments latexminted \
    && apt purge -y python3-pip \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Download update
RUN wget -q -O /tmp/update-tlmgr-latest.sh \
        https://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh && \
    chmod +x /tmp/update-tlmgr-latest.sh

# Update
RUN /tmp/update-tlmgr-latest.sh

# Install everything
RUN tlmgr install scheme-full

# Delete temporary script
RUN rm -f /tmp/update-tlmgr-latest.sh
