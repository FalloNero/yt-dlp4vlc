-- YouTube Link Resolver for VLC with Separate Video and Audio URLs
-- Place this script in VLC's lua/playlist directory

local yt_dlp_path = 'yt-dlp.exe';
local yt_dlp_silent_path = 'ytdlp-silent-xp.exe';

function sleep(s)
  local ntime = os.time() + s
  repeat until os.time() > ntime
end

function probe()
    -- Check if the input is a YouTube link
    return vlc.access == "http" or vlc.access == "https" and 
           (string.match(vlc.path, "youtube%.com") or string.match(vlc.path, "youtu%.be"))
end

function parse()
    -- Construct the full YouTube URL
    local youtube_url = vlc.access .. "://" .. vlc.path

    -- Extract "quality" query parameter if present
    local quality = youtube_url:match("[&?]quality=(%d+)[pP]?")
    youtube_url = youtube_url:gsub("[&?]quality=%d+[pP]?", ""):gsub("[&?]$", "") -- Remove trailing ? or &

    local allowed_qualities = {
        ["360"] = true,
        ["480"] = true,
        ["720"] = true,
        ["1080"] = true,
        ["2160"] = true
    }

    local format_string = "bestvideo+bestaudio" -- Default to highest available
    if quality and allowed_qualities[quality] then
        format_string = string.format("bestvideo[height=%s]+bestaudio", quality)
        vlc.msg.info("Using requested quality: " .. quality .. "p")
    else
        vlc.msg.info("No valid quality specified. Defaulting to best available.")
    end

    local cmd_hidden = yt_dlp_silent_path
    local video_url = ''
    local audio_url = ''

    local yt_dlp_silent_exists = io.open(yt_dlp_silent_path, "r") ~= nil
    if not yt_dlp_silent_exists then
        vlc.msg.info(yt_dlp_silent_path .. " not found. Falling back to " .. yt_dlp_path)
        cmd_hidden = 'PowerShell.exe -windowstyle hidden cmd /c &'

        local cmd = string.format(
            '%s "%s" -f \"%s\" -g --no-warnings  %s',
            cmd_hidden,
            yt_dlp_path,
            format_string,
            youtube_url
        )

        local handle = io.popen(cmd)
        video_url = handle:read("*l")
        audio_url = handle:read("*l")
        handle:close()
    else
        vlc.msg.info(yt_dlp_silent_path .. " found. Running program")
        local cmd = string.format(
            '%s -s "%s -f \"%s\" -g --no-warnings %s"',
            cmd_hidden,
            yt_dlp_path,
            format_string,
            youtube_url
        )

        local process = io.popen("start /B " .. cmd)
        process:close()

        local output_file = "yt-dlp-output.txt"
        local file_exists = false
        local timeout = 0
        local timeout_limit = 10

        while not file_exists do
            local file_test = os.rename(output_file, output_file)
            if file_test then
                file_exists = true
            else
                vlc.msg.info("Waiting for output file...")
                sleep(1)
                timeout = timeout + 1
                if timeout > timeout_limit then
                    vlc.msg.warn("Timeout reached. The output file was not created.")
                    break
                end
            end
        end

        vlc.msg.info("File found")
        local file = io.open(output_file, "r")
        video_url = file:read("*l")
        audio_url = file:read("*l")
        file:close()
        os.remove(output_file)
    end

    video_url = video_url and video_url:gsub("^%s+", ""):gsub("%s+$", "") or ""
    audio_url = audio_url and audio_url:gsub("^%s+", ""):gsub("%s+$", "") or ""

    vlc.msg.info("[YouTube Resolver] Original URL: " .. youtube_url)
    vlc.msg.info("[YouTube Resolver] Video URL: " .. video_url)

    if audio_url and audio_url ~= "" then
        return {
            {
                path = video_url,
                name = vlc.path .. " (Video)",
                options = {
                    ":input-slave=" .. audio_url
                }
            }
        }
    else
        return {
            {
                path = video_url,
                name = vlc.path .. " (Video + Audio)"
            }
        }
    end
end
