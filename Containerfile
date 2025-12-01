FROM docker.io/library/archlinux:latest

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
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        base-devel \
        git \
        nspr \
        nss \
        atk \
        cups \
        gtk3 \
        fuse \
        alsa-lib \
        pipewire-jack \
        opencv \
        blas \
        fmt \
        glew \
        vtk \
        hdf5 \
        python-pip \
        rocminfo \
        ollama-rocm

RUN ln -sf /usr/lib/pkgconfig/opencv4.pc /usr/lib/pkgconfig/opencv.pc

RUN pip install pypatchmatch --break-system-packages

# Enable password less sudo
RUN useradd --no-create-home --shell=/bin/false build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN chown root:root /etc/sudoers
RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

# Build Alpaca-AI from AUR
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay
RUN chown -R build:build /tmp/yay
USER build
WORKDIR /tmp/yay
RUN makepkg -si --noconfirm
USER root
WORKDIR /tmp
RUN rm -rf /tmp/yay
WORKDIR /
RUN yay -S --noconfirm alpaca-ai

RUN echo VARIANT_ID=container >> /etc/os-release