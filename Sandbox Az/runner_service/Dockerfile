FROM python:3.11-slim

# Install required programming language runtimes except Java (we'll install OpenJ9 separately)
RUN apt-get update && apt-get install -y \
    nodejs npm \
    wget \
    ca-certificates \
    golang \
    && npm install -g typescript \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install OpenJ9 (memory-efficient JVM)
RUN mkdir -p /opt/java && \
    wget -q https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.8.1%2B1_openj9-0.40.0/ibm-semeru-open-jdk_x64_linux_17.0.8.1_1_openj9-0.40.0.tar.gz -O /tmp/openjdk.tar.gz && \
    tar -xzf /tmp/openjdk.tar.gz -C /opt/java --strip-components=1 && \
    rm /tmp/openjdk.tar.gz

# Add Java to the PATH and set memory options
ENV PATH="/opt/java/bin:${PATH}"
ENV _JAVA_OPTIONS="-Xmx64m -Xms16m"

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Setup non-root user
RUN useradd -m sandbox

# Create code execution directory with proper permissions
RUN mkdir -p /home/sandbox/code && \
    chown -R sandbox:sandbox /home/sandbox/code && \
    chmod 755 /home/sandbox/code

# Copy application files
COPY run_server.py /app/
COPY code_executor.py /app/
COPY startup.sh /app/

# Set execution permission for startup script
RUN chmod +x /app/startup.sh

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8000

# Expose the port
EXPOSE 8000

# Switch to non-root user for security
USER sandbox

#Set container limits
RUN echo "sandbox soft nproc 1024" >> /etc/security/limits.conf && \
    echo "sandbox hard nproc 2048" >> /etc/security/limits.conf

# Start the application
CMD ["/app/startup.sh"]
