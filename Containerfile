ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ARG DISTRO=ubuntu
ARG RUN_INIT=false
ARG MOCK_OS=""

ENV DEBIAN_FRONTEND=noninteractive
ENV DOTPATH=/root/.dotfiles
ENV HOME=/root

SHELL ["/bin/bash", "-c"]

# Install prerequisites (distro-specific)
RUN if [ "$DISTRO" = "ubuntu" ] || [ "$DISTRO" = "debian" ]; then \
        apt-get update \
        && apt-get install -y sudo make git curl wget bash \
        && rm -rf /var/lib/apt/lists/*; \
    elif [ "$DISTRO" = "fedora" ]; then \
        dnf install -y sudo make git curl wget bash \
        && dnf clean all; \
    elif [ "$DISTRO" = "arch" ]; then \
        pacman -Sy --noconfirm sudo make git curl wget bash; \
    fi \
    && echo 'root ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd-root \
    && chmod 440 /etc/sudoers.d/nopasswd-root

# Install PowerShell (pwsh) for Windows mock PS syntax checking
# Uses GitHub Releases to support both x64 and ARM64
# To upgrade: pass --build-arg PWSH_VERSION=<version>
ARG PWSH_VERSION=7.4.6
RUN if [ "$MOCK_OS" = "windows" ]; then \
        case "$(uname -m)" in \
            x86_64)  PWSH_ARCH="x64"   ;; \
            aarch64) PWSH_ARCH="arm64" ;; \
            armv7l)  PWSH_ARCH="arm32" ;; \
            *) echo "Unsupported arch: $(uname -m)" && exit 1 ;; \
        esac \
        && apt-get update \
        && apt-get install -y libicu70 \
        && rm -rf /var/lib/apt/lists/* \
        && wget -q "https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VERSION}/powershell-${PWSH_VERSION}-linux-${PWSH_ARCH}.tar.gz" \
               -O /tmp/pwsh.tar.gz \
        && mkdir -p /opt/microsoft/powershell/7 \
        && tar -xzf /tmp/pwsh.tar.gz -C /opt/microsoft/powershell/7 \
        && chmod +x /opt/microsoft/powershell/7/pwsh \
        && ln -sf /opt/microsoft/powershell/7/pwsh /usr/local/bin/pwsh \
        && rm -f /tmp/pwsh.tar.gz; \
    fi

WORKDIR /root

COPY . /root/.dotfiles/

# Setup OS mock binaries
RUN bash /root/.dotfiles/etc/test/mock/setup_mocks.sh "$MOCK_OS"

# Deploy dotfiles (create symlinks)
RUN cd /root/.dotfiles && make deploy

# Optionally run full init (install packages etc.)
RUN if [ "$RUN_INIT" = "true" ]; then \
      cd /root/.dotfiles && make init; \
    fi

CMD ["bash", "-c", "cd /root/.dotfiles && make test"]
