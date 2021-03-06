# Plex-NVDEC Docker image
[![](https://images.microbadger.com/badges/version/xeltor/plex-nvdec.svg)](https://microbadger.com/images/xeltor/plex-nvdec "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/xeltor/plex-nvdec.svg)](https://microbadger.com/images/xeltor/plex-nvdec "Get your own image badge on microbadger.com")

This project combines [plexinc/pms-docker](https://github.com/plexinc/pms-docker) with [revr3nd/plex-nvdec](https://github.com/revr3nd/plex-nvdec) to create a docker container with NVDEC support.

## Requirements

- Plex Pass (so you can turn on hardware support)
- Plex Media Server must be a least version 1.15.1.791
- You must have a NVIDIA graphics card and drivers installed with support for NVDEC (check the [NVIDIA Video Encode and Decode GPU Support Matrix](https://developer.nvidia.com/video-encode-decode-gpu-support-matrix) for a list of supported cards)
- Nvidia runtime for Docker. (check [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker#quickstart) for installation instructions on Linux or [Unraid Nvidia Plugin](https://forums.unraid.net/topic/77813-plugin-linuxserverio-unraid-nvidia/?tab=comments#comment-719665) for Unraid)

## Installation
The following example will automatically forward all Plex Media Server ports and enables hardware encoding/decoding on all Nvidia GPU's.
```
docker run \
-d \
--name plex \
--network=host \
--runtime=nvidia \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=compute,video,utility \
-e TZ="<timezone>" \
-e PLEX_CLAIM="<claimToken>" \
-v <path/to/plex/database>:/config \
-v <path/to/transcode/temp>:/transcode \
-v <path/to/media>:/data \
xeltor/plex-nvdec
```
For additional configuration options please check [plexinc/pms-docker](https://github.com/plexinc/pms-docker#parameters).

### How do i use a specific GPU?
1. On your terminal type `nvidia-smi -L` this will show a list of Nvidia devices.
2. Find the UUID of the device you want to assign. (looks something like this: GPU-a75574f4-bb42-e09a-5713-0449f0234604)
3. Change or add the environment variable `NVIDIA_VISIBLE_DEVICES` and set it to the UUID. (e.g. `-e NVIDIA_VISIBLE_DEVICES=GPU-a75574f4-bb42-e09a-5713-0449f0234604`)

### Disable Plex Relay
In case you wish to disable (i.e. remove) Plex Relay upon start-up, add the env `DISABLE_PLEX_RELAY=true` e.g.:

```
docker run -e DISABLE_PLEX_RELAY=true xeltor/plex-nvdec
```

## Examples

### Host Networking

```
docker run \
-d \
--name plex \
--network=host \
--runtime=nvidia \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=compute,video,utility \
-e TZ="<timezone>" \
-e PLEX_CLAIM="<claimToken>" \
-v <path/to/plex/database>:/config \
-v <path/to/transcode/temp>:/transcode \
-v <path/to/media>:/data \
xeltor/plex-nvdec
```

### Macvlan Networking

```
docker run \
-d \
--name plex \
--network=physical \
--ip=<IPAddress> \
--runtime=nvidia \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=compute,video,utility \
-e TZ="<timezone>" \
-e PLEX_CLAIM="<claimToken>" \
-h <HOSTNAME> \
-v <path/to/plex/database>:/config \
-v <path/to/transcode/temp>:/transcode \
-v <path/to/media>:/data \
xeltor/plex-nvdec
```

### Bridge Networking

```
docker run \
-d \
--name plex \
--runtime=nvidia \
-p 32400:32400/tcp \
-p 3005:3005/tcp \
-p 8324:8324/tcp \
-p 32469:32469/tcp \
-p 1900:1900/udp \
-p 32410:32410/udp \
-p 32412:32412/udp \
-p 32413:32413/udp \
-p 32414:32414/udp \
-e NVIDIA_VISIBLE_DEVICES=all \
-e NVIDIA_DRIVER_CAPABILITIES=compute,video,utility \
-e TZ="<timezone>" \
-e PLEX_CLAIM="<claimToken>" \
-e ADVERTISE_IP="http://<hostIPAddress>:32400/" \
-h <HOSTNAME> \
-v <path/to/plex/database>:/config \
-v <path/to/transcode/temp>:/transcode \
-v <path/to/media>:/data \
xeltor/plex-nvdec
```

Note: In this configuration, you must do some additional configuration:

- If you wish your Plex Media Server to be accessible outside of your home network, you must manually setup port forwarding on your router to forward to the `ADVERTISE_IP` specified above.  By default you can forward port 32400, but if you choose to use a different external port, be sure you configure this in Plex Media Server's `Remote Access` settings.  With this type of docker networking, the Plex Media Server is essentially behind two routers and it cannot automatically setup port forwarding on its own.
- (Plex Pass only) After the server has been set up, you should configure the `LAN Networks` preference to contain the network of your LAN.  This instructs the Plex Media Server to treat these IP addresses as part of your LAN when applying bandwidth controls.  The syntax is the same as the `ALLOWED_NETWORKS` below.  For example `192.168.1.0/24,172.16.0.0/16` will allow access to the entire `192.168.1.x` range and the `172.16.x.x` range.
