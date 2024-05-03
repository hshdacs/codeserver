# About Code-Server

- First start with  the [user manual](https://code-server.dev/docs/usage/basics) to get an overview of how code-server
- Code-server is VS Code running on a remote server, accessible through the browser. Code on your chromebook or any other browser with a consistent dev environment.
- Main purpose of this code server  is to provide a simple and convenient way for users to easily develop for linux, in your windows or Mac workstation.
- There is an advantage of large cloud servers to speed up tests, preserve battery life when you're on the go. All intensive computation runs on your server.

# Getting Started

- First Clone this below repository in your system
https://github.com/hshdacs/codeserver.git

- Navigate to the repository
cd codeserver

- You can see multiple folder with different versions  of code-server, choose the latest version.
- You should be installed with docker to run this code-server  image. If you  don't have docker installed please install it from here.  [docker] https://docs.docker.com/engine/install/

# Dockerized Code-Server
This repository contains a Dockerfile and setup script to create a Docker image for running code-server, a web-based version of Visual Studio Code.

## Installation Steps for Dockerized Code Server:

1. Make sure you have docker installed on your machine by running `docker -v` in the terminal. If not, please install it.
2. Select a version from above, you can see the dck.sh file on the codeserver folder.
3. Change directory to the newest version of codeserver, e.g. 4.22.1
4. run this command in your terminal '../dck.sh'
5. It builds a docker image using that specific version.

    # what dck.sh file does?
    - this shell script designed to automate some common docker tasks, such as building docker images and running docker containers.
    - It initializes some variables such as 'COMMAND', 'VERSION', 'IMAGE', 'TAG', 'DETACH', AND 'NAME'.
    - Then it checks if the user is root or not and asks for sudo password if needed.
    - After that it pulls the IMAGE with TAG from Docker Hub.
    - If DETACH is true then it runs the container in background else it will run in foreground.
    - Finally, it prints out the IP address which you can use to access the server.
    - Before building the docker image, it extracts the image name and version from the Dockerfile directory path.
    - the image name is taken from the directory, and the version is taken from the last directory in the path.

4. Run this [command] ' docker run -p 8080:8080 -p 3000:3000 codeserver:4.21.0' - It helps to run the container of already built docker image.
    - here we have opened two ports when  running the container one is 8080 (HTTP) & another is 3000(Websocket).
     
     # what docker file does, when we run this commad
     - Dockerfile utilizes a multi-stage build process, install necessary packages such as 'alpine-sdk', 'libc6-compat', 'nodejs', 'npm', 'python3', - we can also define in this docker file whichever the packages we need it will install automatically.
     - alpine:3.18 as main - setup the main environment for running the code-server instance.
     - installs nodejs (using nvm) & yarn.
     - sets up .bashrc so that bash commands work inside the container.
     - ubuntu:focal as build - used to build the final image.
     - copies all the files from main into build.
     - installs VSCode & extensions required by me.
     - changes the owner of home directory to vscode.
     - makes entrypoint to codeserver-setup.sh executable.

     Overall, this Dockerfile automates tge process of setting up a code-server instance within a docker container, providing users with a lighweight abd portable development environment based on visual studio code. It is written to streamline the deployment and usage of code-server for development purposes.

5. now click on the 8080 port in the docker desktop container. It will redirect to this  link http://localhost:8080/. you can see the visual studio code running on a server.

    # what does codeserver-setup.sh does?

    1. Variable Initialization:
        - It initializes some variables like UID, APKINST, and CSINST.
        - If the script is not running as root (UID != 0), it uses sudo for package installation (APKINST).
    2. First Time Setup:
        * Checks if a VSIX file (chrisdias.vscode-opennewinstance-0.0.12.vsix) exists in /tmp.
        * If found, it installs several VS Code extensions using code-server --install-extension.
        * Removes the VSIX file after installation.
    3. Argument Parsing:
        * Parses the arguments passed to the script.
        * If an argument contains an equal sign (=), it evaluates the expression. Otherwise, it sets the argument to true.
    4. Dependency Installation:
        * Installs various dependencies based on the provided arguments or defaults.
        * Dependencies include Subversion, Python 3 (with Jupyter if specified), Java (default version 17), C/C++ development tools, TCC (Tiny C Compiler), Rust, and PowerShell.
    5. User Setup (if running as root):
        * If running as root, it prepares the user's home directory ($HOME) and sets up some basic configurations.
        * Creates a .bashrc file with an alias for ls -lF.
        * Creates a workspace directory if it doesn't exist.
        * Changes ownership of the home directory to the user coder.
        * Changes the password of the user coder if SUDO_PASSWORD is provided.
    6. Start Code-Server (if running as root):
        * If running as root, it starts code-server as the user coder on port 8080, binding to all available interfaces.
        The script starts code-server with the provided arguments. User can also edit this file with their specified extensions and install.

6. Git setup in your code-server
    - open terminal in your code-server vs code
    - run this command "git config --global user.name 'Your github profile name' ", Next
    - run this command "git config --global user.email 'your github emailid' ", Next
    - you can clone your existing project or create new project.

# License
This project is licensed under the MIT License.

