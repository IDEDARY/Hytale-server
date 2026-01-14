# Based on the requirement for Java 25 and Eclipse Temurin
FROM eclipse-temurin:25-jdk

# Install basic utilities (curl/unzip needed for downloader/handling zip files)
RUN apt-get update && \
    apt-get install -y curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /hytale

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the default UDP port
EXPOSE 5520/udp

# Define volumes for data persistence
VOLUME ["/hytale"]

ENTRYPOINT ["/entrypoint.sh"]