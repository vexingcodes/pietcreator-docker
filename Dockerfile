# Build the PietCreator binary from source.
FROM debian:buster as build

# Install build dependencies.
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
      ca-certificates \
      build-essential \
      cmake \
      git \
      libgd-dev \
      libgif-dev \
      libpng-dev \
      libqt4-dev \
 && rm -rf /var/lib/apt/lists/*

# Compile PietCreator with a small patch to use a newer version of GIFLIB.
COPY pietcreator.patch .
RUN git clone https://github.com/Ramblurr/PietCreator.git \
 && cd PietCreator \
 && git checkout 1645efe343a6672d30543d7ecd46fdb5f049d040 \
 && patch -p1 < /pietcreator.patch \
 && mkdir build \
 && cd build \
 && cmake ../ \
 && make --jobs $(( $(nproc) + 1 ))

# Run the PietCreator binary we just built, exposing the GUI through novnc.
FROM debian:buster as run

# Get the PietCreator binary we built in the previous stage.
COPY --from=build /PietCreator/build/pietcreator /usr/local/bin/pietcreator

# Install runtime dependencies.
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
      libgd3 \
      libgif7 \
      libpng16-16 \
      libqtgui4 \
      novnc \
      supervisor \
      x11vnc \
      xvfb \
 && rm -rf /var/lib/apt/lists/*

# Force vnc_lite.html to be used for novnc, to avoid having the directory listing page.
# Additionally, turn off the control bar.
RUN ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html \
 && sed -i 's/display:flex/display:none/' /usr/share/novnc/app/styles/lite.css

# Configure supervisord.
COPY supervisord.conf /etc/supervisor/supervisord.conf
ENTRYPOINT [ "supervisord", "-c", "/etc/supervisor/supervisord.conf" ]

# Run everything as standard user/group piet.
RUN groupadd piet \
 && useradd --create-home --gid piet piet
WORKDIR /home/piet
USER piet

# Define a default resolution.
ENV RESOLUTION=1920x1080
