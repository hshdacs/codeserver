ARG ALPINE=3.18
FROM alpine:$ALPINE AS build

# in current Alpine distro is no 'nodejs<18' package available
RUN apk --no-cache --update add \
   gcompat libstdc++ \
   alpine-sdk libc6-compat krb5-dev \
   nodejs npm python3
RUN npm install --global code-server --unsafe-perm

FROM alpine:$ALPINE AS main

ARG FULL
ARG SUBVERSION
ARG PYTHON
ARG JUPYTER
ARG JAVA
ARG CPP
ARG TCC
ARG RUST
ARG POWERSHELL

ENV PASSWORD="secret123"
ENV SUDO_PASSWORD=$PASSWORD
ENV SHELL="/bin/bash"
ENV HOME="/code"
ENV CODER_UID=1000
ENV CODER_GID=1000
ENV FULL=${FULL}
ENV SUBVERSION=${SUBVERSION}
ENV JUPYTER=${JUPYTER}
ENV JAVA=${JAVA}
ENV CPP=${CPP}
ENV TCC=${TCC}
ENV RUST=${RUST}
ENV POWERSHELL=${POWERSHELL}

LABEL maintainer="Peter H. Dillinger"

RUN apk --no-cache --update add \
   gcompat libstdc++ \
   bash bash-doc bash-completion \
   grep curl git \
   gnupg openssh-client libsecret \
   nodejs npm su-exec sudo

COPY --from=build /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=build /usr/local/bin /usr/local/bin

# setup user
RUN addgroup -g $CODER_GID coder && \
    addgroup -g 666 sudo && \
    adduser -D -s $SHELL -h $HOME -u $CODER_UID -G coder coder && \
    addgroup coder sudo && \
    sed -i "/^# %sudo/s/^# //" /etc/sudoers && \
    echo "coder:$SUDO_PASSWORD" | chpasswd

# startup files
ADD chrisdias.vscode-opennewinstance-0.0.12.vsix /tmp
ADD codeserver-setup.sh /usr/local/bin
RUN chmod +x /usr/local/bin/codeserver-setup.sh

# ready for deployment
VOLUME [ "$HOME" ]
EXPOSE 8080
CMD [ "/bin/sh", "/usr/local/bin/codeserver-setup.sh" ]
