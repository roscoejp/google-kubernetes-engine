# Transcoding Sample Job
A simple script for creating an ffmpeg Kubernetes job from a Github hosted script. The pods will read a script from the specified Github RAW file (see transcode.sh) and then execute the script. The script in this repo prints some information to the command line and then executes a simple ffmpeg transcode on a test file.

## Using this sample
Job without GPU:
```bash
curl -s https://raw.githubusercontent.com/roscoejp/google-kubernetes-engine/master/ffmpeg/transcode-job.yaml | kubectl create -f -
```

Job with GPU:
```bash
curl -s https://raw.githubusercontent.com/roscoejp/google-kubernetes-engine/master/ffmpeg/long-transcode-job-gpu.yaml | kubectl create -f -
```

## Script details
The transcode script takes in a few environment variables:
`VIDEO_SOURCE` 
`EXTRA_VARS`
`CODEC`

### Pre-reqs
- A functioning GKE cluster with enough resources for the spec you wish to use.

### GPU Notes
- Ensure you've [installed the GPU drivers to your nodes](https://cloud.google.com/kubernetes-engine/docs/how-to/gpus#installing_drivers).
- Uncomment the GPU resource request/limit in the `transcode-job.yaml` pod spec.
- Uncomment the GPU node tolderation in the `transcode-job.yaml` pod spec.

## Why Read a Script from Github?
Reading a script from a remote source allows for quicker testing in my experience. It also allows you to manage your scripts without having to rebuild the container each time. In a production environment you'd want the immutability of a script file in the container, so you'd be better off creating a Dockerfile and then copying your directory into the base image.

## What files are being transcoded?
These test files are taken from several freely available test sources. Note that file download times are not included in the final transcode durations.

>NOTE: One thing I found in these tests is that transcode times are pretty unpredictable given a file's size on disk/length/framerate. I'm not a transcoding or video person by trade so I'm not going to speculate on why this is, I'm just pointing out for anyone reading this. I'd suggest running tests against a set of your own files in order to gauge your own transcode times if you're looking at making a decision on using CPU vs GPU transcoding. See the `Cost Benefit of GPUs` section towards the end for my thoughts on this.

### Big Buck Bunny
This file comes from the [Matroska Org Git Repo](https://github.com/Matroska-Org/matroska-test-files) and is originally from the ['Big Buck Bunny'](https://peach.blender.org/) project.

- File Size: 22.3MB
- Length: 00:01:27
- Stream 0:
  - Codec: MS MPEG-4 (MP42)
  - Resolution: 854x480
  - Frame Rate: 24.000384
- Stream 1:
  - Codec: MPEG Audio (mpga)
  - Channels: Stereo
  - Sample Rate: 4800Hz
  - Bps: 32
  - Bitrate: 160 kb/s

#### Download Time
This file usually takes ~5 seconds to download due to it's small size.
    
#### Performance Log
| CPU Limt | Memory Limit | GPU Limit | Transcode Duration |
| --- | --- | --- | --- |
| 1 vCPU | 2GB | -- | 04 minutes 53 seconds |
| 1 vCPU | 2GB | -- | 04 minutes 52 seconds |
| 1 vCPU | 2GB | 1 GPU | 00 minutes 05 seconds |
| 1 vCPU | 2GB | 1 GPU | 00 minutes 05 seconds |
| 1 vCPU | 2GB | 2 GPU | 00 minutes 05 seconds |
| 1 vCPU | 2GB | 2 GPU | 00 minutes 05 seconds |
| 1 vCPU | 2GB | 4 GPU | 00 minutes 05 seconds |
| 1 vCPU | 2GB | 4 GPU | 00 minutes 05 seconds |
| 6 vCPU | 8GB | -- | 00 minutes 42 seconds |
| 6 vCPU | 8GB | -- | 00 minutes 41 seconds |
| 6 vCPU | 8GB | 1 GPU | 00 minutes 05 seconds |
| 6 vCPU | 8GB | 1 GPU | 00 minutes 05 seconds |
| 6 vCPU | 8GB | 2 GPU | 00 minutes 05 seconds |
| 6 vCPU | 8GB | 2 GPU | 00 minutes 05 seconds |
| 6 vCPU | 8GB | 4 GPU | 00 minutes 05 seconds |
| 6 vCPU | 8GB | 4 GPU | 00 minutes 05 seconds |

### Jell.yfish
This file comes from the [Jellyfish Video Bitrate Test Files](https://jell.yfish.us/) page.

- File Size: 1.4GB
- Length: 00:00:30
- Stream 0:
  - Codec: MPEG-H HEVC (H.265)
  - Resolution: 3840x2160
  - Frame Rate: 29.970628
    
#### Download Time
This file usually takes ~35 seconds to download into the container.

#### Performance Log
| CPU Limt | Memory Limit | GPU Limit | Transcode Duration |
| --- | --- | --- | --- |
| 1 vCPU | 2GB | -- | 09 minutes 31 seconds |
| 1 vCPU | 2GB | -- | 09 minutes 31 seconds |
| 1 vCPU | 2GB | 1 GPU | 00 minutes 01 seconds |
| 1 vCPU | 2GB | 1 GPU | 00 minutes 01 seconds |
| 1 vCPU | 2GB | 2 GPU | 00 minutes 01 seconds |
| 1 vCPU | 2GB | 2 GPU | 00 minutes 01 seconds |
| 1 vCPU | 2GB | 4 GPU | 00 minutes 01 seconds |
| 1 vCPU | 2GB | 4 GPU | 00 minutes 01 seconds |
| 6 vCPU | 8GB | -- | 01 minutes 37 seconds |
| 6 vCPU | 8GB | -- | 01 minutes 37 seconds |
| 6 vCPU | 8GB | 1 GPU | 00 minutes 01 seconds |
| 6 vCPU | 8GB | 1 GPU | 00 minutes 01 seconds |
| 6 vCPU | 8GB | 2 GPU | 00 minutes 01 seconds |
| 6 vCPU | 8GB | 2 GPU | 00 minutes 01 seconds |
| 6 vCPU | 8GB | 4 GPU | 00 minutes 01 seconds |
| 6 vCPU | 8GB | 4 GPU | 00 minutes 01 seconds |

### Tears of Steel
This file comes from the [Jellyfish Video Bitrate Test Files](https://jell.yfish.us/) page.

- File Size: 6.27GB
- Length: 00:12:14
- Stream 0:
  - Codec: H264 - MPEG-4 AVC
  - Resolution: 3840x1714
  - Frame Rate: 24
- Stream 1:
  - Codec: MPEG AAC Audio
  - Channels: Stereo
  - Sample Rate: 44100Hz
  - Bps: 32
    
#### Download Time
This file usually takes ~10 minutes to download into the container.

#### Performance Log
| CPU Limt | Memory Limit | GPU Limit | Transcode Duration |
| --- | --- | --- | --- |
| 1 vCPU | 2GB | -- | 09 minutes 31 seconds |
| 1 vCPU | 2GB | -- | 09 minutes 31 seconds |
| 1 vCPU | 2GB | 1 GPU | 00 minutes 00 seconds |
| 1 vCPU | 2GB | 1 GPU | 00 minutes 01 seconds |
| 1 vCPU | 2GB | 2 GPU | 00 minutes 00 seconds |
| 1 vCPU | 2GB | 2 GPU | 00 minutes 00 seconds |
| 1 vCPU | 2GB | 4 GPU | 00 minutes 00 seconds |
| 1 vCPU | 2GB | 4 GPU | 00 minutes 00 seconds |
| 6 vCPU | 8GB | -- | 01 minutes 37 seconds |
| 6 vCPU | 8GB | -- | 01 minutes 37 seconds |
| 6 vCPU | 8GB | 1 GPU | 00 minutes 01 seconds |
| 6 vCPU | 8GB | 1 GPU | 00 minutes 00 seconds |
| 6 vCPU | 8GB | 2 GPU | 00 minutes 00 seconds |
| 6 vCPU | 8GB | 2 GPU | 00 minutes 00 seconds |
| 6 vCPU | 8GB | 4 GPU | 00 minutes 00 seconds |
| 6 vCPU | 8GB | 4 GPU | 00 minutes 00 seconds |

## Cost Benefit of GPUs
The single biggest factor to consider when comtemplating using GPUs is _how important is it to get jobs done quickly vs cheaply_? This valuation is impossible for me to measure, so you'll need to keep this in mind as you go through and do your own calculations. There are quite a lot of other factors that go into pricing out machines and I don't have the energy to go through all of them in detail, but here's a starter list of what we should be looking at:
- Node [Machine Type](https://cloud.google.com/compute/vm-instance-pricing)
- [GPU Type](https://cloud.google.com/compute/gpus-pricing#gpus)
- Number of GPUs of a given type
- The time it takes to download a file
  - Transcoding costs in general suffer dramatically as source file size increases due to download times not making full use of your available compute power. It may be possible to mitigate this shortcoming by dedicating a certain amount of threads to downloading chunked videos in parallel as another process, but I'm not going to dig into that as I've already spent more time than I like on this project.
- GPU transcodes need less CPU and Memory per job than CPU transcodes
  - This may seem obvious, but it means we can save some money by using lower core count/memory machines with a higher number of GPUs to increase our job concurrency.
- GPUs in general are expensive
  - All of my tests were done using [NVIDIA Tesla P4](https://www.nvidia.com/en-us/deep-learning-ai/inference-platform/hpc/) GPUs. These are middle of the road price wise on GCE.

### Example Math
So to keep this simple, let's look at how many parallel transcode jobs we could fit on 3 similarly priced machines using the specs from our earlier benchmarks:

| Machine Type | vCPU | Memory | GPU | Cost / month | # Concurrent Jobs |
| --- | --- | --- | --- | --- | --- |
| Custom n1 | 60 | 120GB | 0 | $1,289.74 | (1vCPB/2GB) 59 (1 per 1vCPU)|
| Custom n1 | 68 | 90GB | 0 | $1,357.20 | (6vCPB/8GB) 11 (1 per 6vCPU)|
| n1-standard-4 w/ GPU | 14 | 20GB | 0 NVIDIA Tesla P4 | $1,323.49 | 4 (1 per GPU) |

>NOTE: All of these machines have ~2 cores and a few GB of memory left over for other things like kubeDNS and Kubernetes controllers.

#### Low Power CPU Transcoding (1vCPU/2GB RAM)
Using our low power CPU transcoding we get _a ton_ of concurrency in our jobs, but our individual job times are pretty long.

| Source Download Time | Transcode Time | Total Job Time | Jobs / month per thread | Total jobs / month | Cost / job |
| --- | --- | --- | --- | --- | --- |
| 5s | 293s | 298s | 8697 | 5,132,233 | $0.0002 |
| 35s | 540s | 575s | 4,507 | 265,913 | $0.0049 |
| 600s | 540s | 1140s | 2,273 | 134,107 | $0.0096 |

#### High Power CPU Transcoding (6vCPU/8GB RAM)
Switching to our high power CPU transcodign, we get less concurrency, but our job times are pretty reasonable.

| Source Download Time | Transcode Time | Total Job Time | Jobs / month per thread | Total jobs / month | Cost / job |
| --- | --- | --- | --- | --- | --- |
| 5s | 42s | 47s | 55,148 | 606,628 | $0.0022 |
| 35s | 97s | 132s | 19,636 | 215,996 | $0.0063 |
| 600s | 97s | 697s | 3,718 | 40,898 | $0.0324 |

#### GPU Transcoding
And finally GPU transcoding. We get the lowest concurrency here because GPUs are so expensive, but our jobs are lightning fast. Unfortunately this means that download time has the largest impact on GPU efficiency as that's where almost all of our job time is spent.

| Source Download Time | Transcode Time | Total Job Time | Jobs / month per thread | Total jobs / month | Cost / job |
| --- | --- | --- | --- | --- | --- |
| 5s | 5s | 10s | 259,200 | 1,036,800 | $0.0013 |
| 35s | 5s | 40s | 64,800 | 259,200 | $0.0051 |
| 600s | 5s | 605s | 4,284 | 17,136 | $0.0772 |

### Some Sample Formulas
Here are some quick sample formulas you can use with your own numbers.
- `DOWNLOAD_TIME` and `TRANSCODE_TIME`: time for the download and transcode actions in seconds
- `NODE_CONCURRENCY`: the number of concurrent jobs that can run on your node. This would be the lower of `${RESOURCE_CPU_LIMIT} / ${NODE_CPU}` or `${RESOURCE_MEMORY_LIMIT} / ${NODE_MEMORY}` in Kubernetes.
- `NODE_COST_PER_MONTH`: the cost of running a given node in a month.

___Total Jobs per Month___
```bash
= 2592000 / (${DOWNLOAD_TIME} + ${TARNSCODE_TIME}) * ${NODE_CONCURRENCY}
```
___Cost per Job___
```bash
= ${NODE_COST_PER_MONTH} / ${TOTAL_JOBS_PER_MONTH}
```
or
```bash
= ${NODE_COST_PER_MONTH} / (2592000 / (${DOWNLOAD_TIME} + ${TARNSCODE_TIME}) * ${NODE_CONCURRENCY})
```
