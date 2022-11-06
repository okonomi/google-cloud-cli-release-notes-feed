#/usr/bin/env bash

set -xe -o pipefail

curl https://cloud.google.com/sdk/docs/release-notes | ruby release_notes_to_feed.rb | jq > docs/feed.json

FEED_ITEM_COUNT=$(cat docs/feed.json | jq ".items | length")
PAGE_COUNT=$((($FEED_ITEM_COUNT + 30 - 1) / 30))

mkdir -p docs/feeds
for i in $(seq 0 $(($PAGE_COUNT - 1))); do
  cat docs/feed.json | ruby ./split_feed.rb $PAGE_COUNT $i | jq > docs/feeds/$i.json
done
