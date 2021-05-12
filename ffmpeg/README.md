# Transcoding Sample Job

A simple script for creating an ffmpeg Kubernetes job from a Github hosted script. The pods will read a script from the specified Github RAW file (see transcode.sh) and then execute the script. The script in this repo prints some information to the command line and then executes a simple ffmpeg transcode on a test file.

## Why Read a Script from Github?

Reading a script from a remote source allows for quicker testing in my experience. It also allows you to manage your scripts without having to rebuild the container each time. In a production environment you'd want the immutability of a script file in the container, so you'd be better off creating a Dockerfile and then copying your directory into the base image.

## What file is being transcoded?

Tests use a test file from the 'Chuck the Bunny' open source project: https://github.com/Matroska-Org/matroska-test-files.
- File Size:  22.3MB
- Length:     00:01:27
- Stream 0:
  - Codec:      MS MPEG-4 (MP42)
  - Resolution: 854x480
  - Frame Rate: 24.000384
- Stream 1:
  - Codec:      MPEG Audio (mpga)
  - Channels:   Stereo
  - Sample Rate:4800Hz
  - Bps:        32
  - Bitrate:    160 kb/s
    
## Performance Log
| CPU Limt | Memory Limit | TPU Limit | Transcode Duration |
| --- | --- | --- | --- |
| 1 vCPU | 2GB | -- | 0 days 00 hours 04 minutes 53 seconds |
| 1 vCPU | 2GB | -- | 0 days 00 hours 04 minutes 52 seconds |
| 1 vCPU | 2GB | -- | 0 days 00 hours 03 minutes 53 seconds |
| 1 vCPU | 2GB | 1 GPU | ??? |
| 1 vCPU | 2GB | 1 GPU | ??? |
| 6 vCPU | 8GB | -- | 0 days 00 hours 00 minutes 42 seconds |
| 6 vCPU | 8GB | -- | 0 days 00 hours 00 minutes 41 seconds |
| 6 vCPU | 8GB | -- | 0 days 00 hours 00 minutes 41 seconds |
| 6 vCPU | 8GB | 1 GPU | ??? |
| 6 vCPU | 8GB | 1 GPU | ??? |

## Using this sample

`kubectl create -f https://raw.githubusercontent.com/roscoejp/google-kubernetes-engine/master/ffmpeg/transcode-job.yaml`

### Pre-reqs

- A functioning GKE cluster with enough resources for the spec you wish to use.

### GPU Notes

- Ensure you've [installed the GPU drivers to your nodes](https://cloud.google.com/kubernetes-engine/docs/how-to/gpus#installing_drivers).
- Uncomment the GPU resource request/limit in the `transcode-job.yaml` pod spec.
- Uncomment the GPU node tolderation in the `transcode-job.yaml` pod spec.
