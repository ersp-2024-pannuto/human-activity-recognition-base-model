# Use a base image with Python 3.10
FROM python:3.10-slim

# Install the necessary system dependencies (including dependencies to install specific Python versions)
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.10.11 specifically
RUN curl -sS https://www.python.org/ftp/python/3.10.11/Python-3.10.11.tgz | tar -xz -C /opt && \
    cd /opt/Python-3.10.11 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall

# Set python3.10 as the default python version
RUN ln -s /usr/local/bin/python3.10 /usr/bin/python && \
    ln -s /usr/local/bin/pip3.10 /usr/bin/pip

# Verify the Python version
RUN python --version

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container
COPY requirements.txt /app/

# Upgrade pip to the latest version
RUN pip install --upgrade pip

# Install the Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Optionally, copy the rest of the application files into the container
COPY . /app/

# Set the default command to run your script (if you have one)
# CMD ["python", "your_script.py"]
