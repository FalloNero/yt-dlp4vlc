# VLC yt-dlp Lua Wrapper

A simple Lua script that integrates **yt-dlp** into **VLC**, allowing you to stream supported online videos by opening a network URL in VLC.

## Features

- Wraps `yt-dlp.exe` for use inside VLC
- By default requires `yt-dlp.exe` to be in the VLC directory  
  (the path can be changed directly in the script)
- Hides the command prompt window while yt-dlp processes the URL:
  - Uses a PowerShell command by default
  - Automatically uses `yt-dlp-silent.exe` if found (a small C++ wrapper that suppresses the console without PowerShell)

## Requirements

- Windows
- VLC Media Player
- `yt-dlp.exe` or `yt-dlp-silent.exe`

## Installation

1. Copy the Lua script into VLC’s Lua playlist directory:

`VLC\lua\playlist\`

2. Place `yt-dlp.exe` (or `yt-dlp-silent.exe`) in the VLC directory  
or edit the script to point to its location.
3. Restart VLC.

## Usage

1. Open VLC.
2. Go to **Media → Open Network Stream**.
3. Paste a supported video URL and click **Play**.

VLC will call yt-dlp, resolve the stream, and start playback automatically.

## Video Quality Selection

Append the `quality` parameter to the URL to force a specific resolution:

`&quality=xxx`

Supported values:

- `360p`
- `480p`
- `720p`
- `1080p`
- `2160p`

If omitted, the script defaults to the highest available quality.
