#!/bin/sh

if [ -z "$UID" ]; then
  UID=`id -u`
fi

APKINST="/sbin/apk --no-cache add"
CSINST="code-server --install-extension"
if [ $UID -ne 0 ]; then
  APKINST="sudo $APKINST"
fi

if [ -s /tmp/chrisdias.vscode-opennewinstance-0.0.12.vsix ]; then
  # first time setup
  FIRSTINIT=1

  ${CSINST} formulahendry.code-runner --force
  ${CSINST} pkief.material-icon-theme --force
  ${CSINST} adamraichu.zip-viewer --force
  ${CSINST} phil294.git-log--graph --force
  ${CSINST} anwar.papyrus-pdf --force
  ${CSINST} tomoyukim.vscode-mermaid-editor --force

  # https://marketplace.visualstudio.com/items?itemName=chrisdias.vscode-opennewinstance
  ${CSINST} /tmp/chrisdias.vscode-opennewinstance-0.0.12.vsix
  rm -f /tmp/chrisdias.vscode-opennewinstance-0.0.12.vsix
fi

for arg in $*; do
  if [ `expr "$arg" : ".*=.*"` -gt 0 ]; then
    eval "$arg"
  else
    eval "$arg=true"
  fi
done

# Subversion
if [ -n "$SUBVERSION" -o -n "$FULL" ]; then
    ${APKINST} subversion &&
    ${CSINST} johnstoncode.svn-scm
fi

# Python (v3)
if [ -n "$PYTHON" -o -n "$FULL" ]; then
    ${APKINST} python3
    ${CSINST} edwinkofler.vscode-hyperupcall-pack-python
    if [ -n "$JUPYTER" -o -n "$FULL" ]; then
        ${APKINST} py3-pip &&
        ${CSINST} ms-toolsai.jupyter
    fi
fi

# Java (v17 if not provided)
if [ -n "$JAVA" -o -n "$FULL" ]; then
    if [ `expr "$JAVA" : "[0-9][0-9]*"` -eq 0 ]; then
      JAVA=17
    fi
    ${APKINST} openjdk${JAVA}-jdk &&
    ${CSINST} vscjava.vscode-java-pack
fi

# C/C++
if [ -n "$CPP" -o -n "$FULL" ]; then
    ${APKINST} build-base clang clang-dev cmake &&
    ${CSINST} franneck94.vscode-c-cpp-dev-extension-pack
fi

# TCC
if [ -n "$TCC" -o -n "$FULL" ]; then \
   ${APKINST} tcc tcc-libs tcc-libs-static tcc-dev tcc-doc \
       --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
fi

# Rust
if [ -n "$RUST" -o -n "$FULL" ]; then
    ${APKINST} rust rust-doc rust-clippy rust-gdb rust-analyzer rustfmt cargo cargo-doc cargo-bash-completions &&
    ${CSINST} pinage404.rust-extension-pack
fi

# Powershell
if [ -n "$POWERSHELL" -o -n "$FULL" ]; then
    ${APKINST} powershell &&
    ln -s /usr/bin/pwsh /usr/local/bin/powershell &&
    ${CSINST} ms-vscode.powershell
fi

# prepare $HOME
if [ -n "$FIRSTINIT" ]; then
    if [ ! -s $HOME/.bashrc ]; then
        echo "alias dir='ls -lF'" > $HOME/.bashrc
    fi
    if [ ! -e $HOME/workspace/ ]; then
        mkdir $HOME/workspace
    fi
    chown -R coder:coder $HOME
    unset SUDO_PASSWORD
fi

# start codeserver
if [ $UID -eq 0 ]; then
    /sbin/su-exec coder /usr/local/bin/code-server --bind-addr 0.0.0.0:8080
fi
