# Getting Started

- Clone the repository
https://github.com/hshdacs/codeserver.git

- Navigate to the repository
cd codeserver

# Dockerized Code-Server
This repository contains a Dockerfile and setup script to create a Docker image for running code-server, a web-based version of Visual Studio Code.

# Features

Easily set up a code-server environment within a Docker container.
Customize the development environment by specifying options during container initialization.

# Requirements

Docker installed on your system.

# Usage 

-Building the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:
" docker build -t codeserver. "

-Running the Docker Container

Once the Docker image is built, you can run a container based on this image using the following command:
"docker run -p 8080:8080 codeserver"
# Access code-server by visiting http://localhost:8080 in your web browser.

# Customization

You can customize the container environment by passing options to the Docker run command. Some common options include:

-d: Run the container in detached mode.
--name <container_name>: Assign a custom name to the container.
-v <host_path>:<container_path>: Mount a volume from the host into the container.
-e <environment_variable>=<value>: Set environment variables inside the container.
--restart <policy>: Set restart policy for the container.
Refer to the Docker documentation for more details on these options.


# Documentation
For more detailed documentation on code-server and its usage, refer to the code-server documentation.
https://github.com/coder/code-server


# License
This project is licensed under the MIT License.

