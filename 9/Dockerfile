FROM craftdock/alpine-runit:latest

ENV NODE_VERSION 9.5.0
ENV YARN_VERSION 1.3.2

# Create node user
RUN set -x && addgroup -g 1000 -S node && adduser -u 1000 -S -D -G node node

# Install node
RUN \
	# Print executed commands
	set -x \
    # Update repository indexes
    && apk-update \
    # Add packages
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        libstdc++ \
    # Add temporary packages
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --virtual .build-dependencies \
        binutils-gold \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
    # Download and install
    && curl -sfSLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure --prefix=/usr \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && cd .. \
    # Remove files
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" \
	# Clear apk's cache
	&& apk-remove .build-dependencies \
	&& apk-cleanup \
    # Extra cleaning
    && rm -rf /usr/include /node-v$NODE_VERSION* /usr/share/man  \
    /root/.npm /root/.node-gyp /root/.gnupg \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts


# Install yarn
RUN \
	# Print executed commands
	set -x \
    # Update repository indexes
    && apk-update \
    # Add packages
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        libstdc++ \
    # Add temporary packages
    && apk-install --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --virtual .build-dependencies \
        curl \
        gnupg \
        tar \
    # Download and install
    && curl -sfSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && mkdir -p /opt/yarn \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
    # Remove files
    && rm yarn-v$YARN_VERSION.tar.gz \
	# Clear apk's cache
	&& apk-remove .build-dependencies \
	&& apk-cleanup \
    # Extra cleaning
    && rm -rf /usr/include /node-v$NODE_VERSION* /usr/share/man  \
    /root/.npm /root/.node-gyp /root/.gnupg \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts

# Copy scripts
COPY ./rootfs /
