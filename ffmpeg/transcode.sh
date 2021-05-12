#!/usr/bin/env bash

# Job Info
echo "========================================"
echo "Starting Job: ${JOB_NAME}"

# Check ffmpeg version
ffmpeg -version

# Remote filename
VIDEO_SOURCE="https://github.com/Matroska-Org/matroska-test-files/blob/master/test_files/test1.mkv?raw=true"

# Download file
START_TIME=$(date +%s)
curl -o source.mkv -LJO "${VIDEO_SOURCE}"
DURATION=$(expr $(date +%s) - $START_TIME)
eval "echo Download duration was: $(date -ud "@$DURATION" +'$((%s/3600/24)) days %H hours %M minutes %S seconds')"

# Transcode
START_TIME=$(date +%s)
ffmpeg \
    ${EXTRA_VARS} \
    -i ./source.mkv \
    -c:v ${CODEC} \
    -b:v 4M \
    -vf scale=1280:720 \
    -c:a copy \
    ./output.mkv
DURATION=$(expr $(date +%s) - $START_TIME)
eval "echo Transcode duration was: $(date -ud "@$DURATION" +'$((%s/3600/24)) days %H hours %M minutes %S seconds')"
