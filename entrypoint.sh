#!/bin/bash
set -e

# Configuration
JAR_NAME="HytaleServer.jar"
ASSETS_NAME="Assets.zip"
JAVA_MEMORY="${JAVA_MEMORY:-4G}"
ADDITIONAL_ARGS=""

echo "--- Hytale Server Docker Container ---"
java --version

# --- Locate the Server Jar ---
if [ -f "$JAR_NAME" ]; then
    JAR_PATH="$JAR_NAME"
    echo "Status: Found $JAR_NAME in root directory."
elif [ -f "Server/$JAR_NAME" ]; then
    JAR_PATH="Server/$JAR_NAME"
    echo "Status: Found $JAR_NAME in 'Server' subdirectory."
else
    echo "ERROR: Could not find $JAR_NAME in /hytale or /hytale/Server."
    exit 1
fi

# --- Locate Assets ---
if [ -f "$ASSETS_NAME" ]; then
    ASSETS_PATH="$ASSETS_NAME"
else
    echo "WARNING: $ASSETS_NAME not found in /hytale. Server may fail to start."
    ASSETS_PATH="$ASSETS_NAME"
fi

# --- Locate AOT Cache ---
# Check the same directory where the JAR was found
JAR_DIR=$(dirname "$JAR_PATH")
AOT_FILE="$JAR_DIR/HytaleServer.aot"

if [ -f "$AOT_FILE" ]; then
    echo "Status: AOT Cache found ($AOT_FILE). Enabling optimizations."
    AOT_FLAG="-XX:AOTCache=$AOT_FILE"
else
    echo "Status: No AOT Cache found. Starting without AOT optimization."
    AOT_FLAG=""
fi

# --- Handle Sentry Argument ---
if [ "$DISABLE_SENTRY" = "true" ]; then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --disable-sentry"
fi

echo "--- Launching Server ---"
echo "Command: java -Xmx$JAVA_MEMORY $AOT_FLAG -jar $JAR_PATH --assets $ASSETS_PATH"

exec java \
    -Xmx"$JAVA_MEMORY" \
    $AOT_FLAG \
    -jar "$JAR_PATH" \
    --assets "$ASSETS_PATH" \
    --bind 0.0.0.0:5520 \
    $ADDITIONAL_ARGS \
    "$@"