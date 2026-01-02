VLC yt-dlp Lua Wrapper

A simple Lua script that integrates yt-dlp directly into VLC, allowing you to stream supported online videos by simply opening a network URL in VLC.

Features

Wraps yt-dlp.exe for seamless use inside VLC

By default, expects yt-dlp.exe in the VLC directory

The path can be easily changed inside the script

Automatically hides the command window while yt-dlp resolves the stream:

Uses a PowerShell command by default

If yt-dlp-silent.exe is found, it will be used instead (a small C++ wrapper that suppresses the console without PowerShell)

Usage

Place the Lua script in VLC’s Lua playlist directory.

Make sure yt-dlp.exe (or yt-dlp-silent.exe) is available.

In VLC, select Media → Open Network Stream.

Paste a supported video URL and play.

Video Quality Selection

You can force a specific video quality by appending the quality parameter to the URL:

&quality=xxx


Supported values:

360p

480p

720p

1080p

2160p

If the parameter is omitted, the script defaults to the highest available quality.

Notes

Requires Windows (due to PowerShell / executable usage).

VLC must have Lua playlist scripts enabled (default behavior).
