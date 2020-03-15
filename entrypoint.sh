#!/bin/bash

# $1 :: ${{ inputs.auth }}
# $2 :: ${{ inputs.gist_url }}
# $3 :: ${{ inputs.gist_title }}
# $4 :: ${{ inputs.gist_description }}
# $5 :: ${{ inputs.github_file }}

auth_token=$1

gist_api="https://api.github.com/gists/"
gist_id=$(grep -Po "\w+$" <<< $2)
gist_endpoint=$gist_api$gist_id

title=$(echo $3 | sed 's/\"/\\"/g')
description=$(echo $4 | sed 's/\"/\\"/g')
content=$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' $5 | sed 's/\"/\\"/g')


curl -s -X PATCH \
    -H "Content-Type: application/json" \
    -H "Authorization: token $auth_token" \
    -d '{"description": "'"$description"'", "files": {"'"$title"'": {"content": "'"$content"'"}}}' $gist_endpoint
