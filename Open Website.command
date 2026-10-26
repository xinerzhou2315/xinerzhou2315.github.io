#!/bin/bash
cd "$(dirname "$0")"
export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"
PORT=8765
URL="http://127.0.0.1:${PORT}/"

echo "Building the site from your latest edits..."
if ! bundle exec jekyll build; then
  echo ""
  echo "The build failed, so the preview was not updated."
  echo "Press Return to close this window."
  read -r
  exit 1
fi

if ! curl -sf -o /dev/null --max-time 1 "$URL"; then
  python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "_site" &
  for _ in 1 2 3 4 5 6 7 8 9 10; do
    curl -sf -o /dev/null --max-time 1 "$URL" && break
    sleep 0.2
  done
fi

open "$URL"
echo ""
echo "The site is open at ${URL}"
echo "This preview includes the edits saved before this window opened."
echo "Leave this window open while you look at the site. Closing it stops the preview."
echo ""
wait
