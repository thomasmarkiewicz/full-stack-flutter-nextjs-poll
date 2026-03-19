FROM mcr.microsoft.com/devcontainers/typescript-node:20

# Install Bun, Flutter prerequisites, ADB, and Java
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl git unzip xz-utils zip libglu1-mesa \
    clang cmake ninja-build pkg-config libgtk-3-dev adb \
    openjdk-21-jdk-headless \
    && npm install -g pnpm \
    && curl -fsSL https://bun.sh/install | bash

# Add Bun to PATH for the node user
ENV BASH_ENV="/home/node/.bashrc"
RUN echo "export PATH=\"/home/node/.bun/bin:\$PATH\"" >> /home/node/.bashrc

# ── Android SDK ──────────────────────────────────────────────────────────────
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=${ANDROID_SDK_ROOT}
ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}

# Install cmdline-tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && cd /tmp \
    && curl -fsSL https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o cmdline-tools.zip \
    && unzip -q cmdline-tools.zip \
    && mv cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm cmdline-tools.zip

# Accept all licenses and install required SDK components (incl. NDK Flutter auto-pulls)
RUN yes | sdkmanager --licenses \
    && sdkmanager \
        "platform-tools" \
        "platforms;android-36" \
        "build-tools;36.0.0" \
        "ndk;27.0.12077973" \
    && chown -R node:node ${ANDROID_SDK_ROOT} \
    # Make the apt-installed SDK writable and symlink build-tools so Flutter's aapt lookup works
    && mkdir -p /usr/lib/android-sdk \
    && chown -R node:node /usr/lib/android-sdk \
    && ln -sf ${ANDROID_SDK_ROOT}/build-tools /usr/lib/android-sdk/build-tools

# Install Flutter SDK globally
ENV FLUTTER_HOME=/opt/flutter
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=${FLUTTER_HOME}/bin:${JAVA_HOME}/bin:${PATH}

RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git ${FLUTTER_HOME} \
    && flutter config --no-analytics \
    && flutter config --android-sdk ${ANDROID_SDK_ROOT} \
    && flutter precache \
    && chown -R node:node ${FLUTTER_HOME} \
    && chmod -R a+rw ${FLUTTER_HOME}