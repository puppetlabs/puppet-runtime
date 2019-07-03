#!/bin/sh

for file in $RUNTIME_FILE $SETTINGS_FILE; do
  calculated_sha=$(sha1sum $file | cut -d ' ' -f 1)
  sha_from_file=$(cat $file.sha1 | cut -d ' ' -f 1)

  if [ "$calculated_sha" != "$sha_from_file" ]; then
    echo "ERROR: Unable to validate $file"
  else
    echo "SUCCESS: validated $file"
  fi
done
