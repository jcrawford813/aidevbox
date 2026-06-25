FROM docker.io/library/debian:trixie

LABEL com.github.containers.toolbox="true" \
      name="aidev-distrobox" \
      version="latest" \
      usage="This image is meant to be used with the distrobox command" \
      summary="Custom image for AI development" \
      maintainer="jim@mycodinglife.com"

# Enable myhostname nss plugin for clean hostname resolution without patching
# hosts (at least for sudo), add it right after 'files' entry. We expect that
# this entry is not present yet. Do this early so that package postinst (which
# adds it too late in the order) skips this step
RUN sed -Ei 's/^(hosts:.*)(\<files\>)\s*(.*)/\1\2 myhostname \3/' /etc/nsswitch.conf

# Install packages
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
        rocminfo \
        pip \
        fuse \
        libnspr4 \
        libnss3 \
        alsa-tools \
        libopencv-dev \
        python3-opencv \
        sudo

RUN curl -fsSL https://lmstudio.ai/download/latest/linux/x64?format=deb
RUN apt install -y ./*.deb

RUN pip install pypatchmatch --break-system-packages
RUN pip install --pre torch torchvision torchaudio --index-url https://rocm.nightlies.amd.com/v2/gfx110X-all/ --break-system-packages

# Enable password less sudo
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN chown root:root /etc/sudoers
RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

RUN echo VARIANT_ID=container >> /etc/os-release