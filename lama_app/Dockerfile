# Install Operating system and dependencies
FROM debian:stable-slim as build
ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

# download Flutter SDK from Flutter Github repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter environment path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

FROM debian:stable-slim
WORKDIR /app/
COPY --from=build /app/build/web /app/
COPY server/server.sh /server/server.sh

RUN apt-get update
RUN apt-get install -y python3
RUN apt-get clean

# make server startup script executable and start the web server
RUN ["chmod", "+x", "/server/server.sh"]

ENTRYPOINT [ "/server/server.sh"]