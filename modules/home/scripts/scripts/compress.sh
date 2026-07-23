if (( $# != 1 )); then
  echo "Usage: compress <file-or-directory>" >&2
  exit 2
fi

source_path="$1"
archive_path="${source_path%/}.tar.gz"

tar -czvf "$archive_path" -- "$source_path"
