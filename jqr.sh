mkvmerge -J Filename.mkv | jq -r ' .tracks | map("Track ID" + ": " + (.id | tostring) + " " + .type + " " + "language:" + .properties.language) | join("\n") '
mkvmerge -J Filename.mkv | jq -r ' .tracks | map(select(.type == "audio") | .id) | map(tostring)  | join(",")'
