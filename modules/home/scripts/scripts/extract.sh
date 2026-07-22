if (( $# == 0 )); then
  echo "Usage: extract <archive.tar.gz> [...]" >&2
  exit 2
fi

for archive in "$@"; do
  if [[ ! -f "$archive" ]]; then
    echo "Archive not found: $archive" >&2
    exit 1
  fi

  tar -xzvf "$archive"
done
