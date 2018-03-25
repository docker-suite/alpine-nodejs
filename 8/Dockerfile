# NodeJs apk builder
FROM craftdock/apk-nodejs:8 as nodejs_apk_builder

ENV PACKAGER "Hexosse <hexosse@gmail.com>"

RUN set -x \
    # Build Hugo apk file
    && /entrypoint abuild -r -P /packages \
    # Copy packages outside of builder volume
    && sudo cp -r /packages /tmp/nodejs
    


# NodeJs    
FROM craftdock/alpine-runit:latest

LABEL maintainer="Hexosse <hexosse@gmail.com>" \
      description="Minimal Alpine image with NodeJs and Yarn."

ENV NODE_VERSION 8.10.0
ENV YARN_VERSION 1.5.1

COPY --from=nodejs_apk_builder /tmp/nodejs /tmp/nodejs

RUN \
	# Print executed commands
	set -x \
    # Update repository indexes
    && apk-update \
    # NodeJs need libuv >= 1.18.0
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ libuv \
    # Install NodeJs
    && apk-install --repository /tmp/nodejs --allow-untrusted nodejs nodejs-npm \
    # Install Yarn
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ yarn \
	# Clear apk's cache
	&& apk-cleanup \
    # Extra cleaning
    && rm -rf /usr/include /node-v$NODE_VERSION* /usr/share/man  \
    /root/.npm /root/.node-gyp /root/.gnupg

# Copy scripts
COPY /rootfs /
