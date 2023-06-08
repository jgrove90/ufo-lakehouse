# Base image
FROM python:3.10.6-slim-bullseye

# Project folder name
ARG PROJECT_FOLDER=ufo-lakehouse

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY ./requirements.txt /opt/${PROJECT_FOLDER}/requirements.txt
RUN python -m pip install --no-cache-dir -r /opt/${PROJECT_FOLDER}/requirements.txt

# Expose port for jupyter lab
EXPOSE 8888

# Copy local directory into container app directory
WORKDIR /opt/${PROJECT_FOLDER}
COPY . /opt/${PROJECT_FOLDER}

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && \
    chown -R appuser /opt/${PROJECT_FOLDER}


USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser"]