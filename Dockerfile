FROM alpine:latest AS build

RUN apk --no-cache --update add \
   gcompat libstdc++ \
   alpine-sdk libc6-compat krb5-dev \
   nodejs npm python3
RUN npm install --global code-server --unsafe-perm

FROM alpine:latest AS main

ARG FULL
ARG SUBVERSION
ARG PYTHON
ARG JUPYTER
ARG JAVA
ARG CPP
ARG TCC
ARG RUST
ARG POWERSHELL

ENV PASSWORD="geheim123"
ENV SUDO_PASSWORD=$PASSWORD
ENV SHELL="/bin/bash"
ENV HOME="/code"
ENV CODER_UID=1000
ENV CODER_GID=1000

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

# VS Code Extensions
RUN code-server --install-extension formulahendry.code-runner

# Subversion
RUN if [ -n "$SUBVERSION" -o -n "$FULL" ]; then \
      apk --no-cache add subversion && \
      code-server --install-extension johnstoncode.svn-scm ;\
    fi

# Python (v3)
RUN if [ -n "$PYTHON" -o -n "$JUPYTER" -o -n "$FULL" ]; then \
      apk --no-cache add python3 && \
      code-server --install-extension edwinkofler.vscode-hyperupcall-pack-python ;\
      if [ -n "$JUPYTER" -o -n "$FULL" ]; then \
         apk --no-cache add py3-pip && \
         code-server --install-extension ms-toolsai.jupyter ;\
      fi; \
    fi

# Java (v17)
RUN if [ -n "$JAVA" -o -n "$FULL" ]; then \
      apk --no-cache add openjdk17-jdk && \
      code-server --install-extension vscjava.vscode-java-pack ;\
    fi

# C/C++
RUN if [ -n "$CPP" -o -n "$FULL" ]; then \
      apk --no-cache add build-base clang clang-dev cmake && \
      code-server --install-extension franneck94.vscode-c-cpp-dev-extension-pack ;\
    fi

# TCC
RUN if [ -n "$TCC" -o -n "$FULL" ]; then \
      apk --no-cache add tcc tcc-libs tcc-libs-static tcc-dev tcc-doc --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted ;\
    fi

# Rust
RUN if [ -n "$RUST" -o -n "$FULL" ]; then \
      apk --no-cache add rust rust-doc rust-clippy rust-gdb rust-analyzer rustfmt cargo cargo-doc cargo-bash-completions && \
      code-server --install-extension pinage404.rust-extension-pack ;\
    fi

# Powershell
RUN if [ -n "$POWERSHELL" -o -n "$FULL" ]; then \
      apk --no-cache add powershell && \
      ln -s /usr/bin/pwsh /usr/local/bin/powershell && \
      code-server --install-extension ms-vscode.powershell ;\
    fi

# prepare $HOME
RUN echo "alias dir='ls -lF'" > $HOME/.bashrc
RUN chown -R coder:coder $HOME

# ready for deployment
VOLUME [ "$HOME" ]
EXPOSE 8080
CMD [ "/bin/sh", "-c", "/sbin/su-exec coder /usr/local/bin/code-server --bind-addr 0.0.0.0:8080" ]
