#
# Creates archive file
#
# Authors:
#   Matt Hamilton <m@tthamilton.com>
#

function archive {

local archive_name path_to_archive _gzip_bin _bzip2_bin _xz_bin _zstd_bin

if (( $# < 2 )); then
  cat >&2 <<EOF
usage: $0 [archive_name.zip] [/path/to/include/into/archive ...]

Where 'archive.zip' uses any of the following extensions:

.tar.gz, .tar.bz2, .tar.xz, .tar.lzma, .tar.zst, .tar, .zip, .rar, .7z

There is no '-v' switch; all operations are verbose.
EOF
return 1
fi

# we are quitting (above) if there are not exactly 2 vars,
#  so we don't need any argc check here.

# strip the path, just in case one is provided for some reason
archive_name="${1:t}"
# let paths be handled by actual archive helper
path_to_archive="${@:2}"

# here, we check for dropin/multi-threaded replacements
# this should eventually be moved to modules/archive/init.zsh
# as a global alias
if (( $+commands[pigz] )); then
  _gzip_bin='pigz'
else
  _gzip_bin='gzip'
fi

if (( $+commands[pixz] )); then
  _xz_bin='pixz'
else
  _xz_bin='xz'
fi

if (( $+commands[lbzip2] )); then
  _bzip2_bin='lbzip2'
elif (( $+commands[pbzip2] )); then
  _bzip2_bin='pbzip2'
else
  _bzip2_bin='bzip2'
fi

_zstd_bin='zstd'

case "${archive_name}" in
  (*.tar.gz|*.tgz) tar -cvf "${archive_name}" --use-compress-program="${_gzip_bin}" "${=path_to_archive}" ;;
  (*.tar.bz2|*.tbz|*.tbz2) tar -cvf "${archive_name}" --use-compress-program="${_bzip2_bin}" "${=path_to_archive}" ;;
  (*.tar.xz|*.txz) tar -cvf "${archive_name}" --use-compress-program="${_xz_bin}" "${=path_to_archive}" ;;
  (*.tar.lzma|*.tlz) tar -cvf "${archive_name}" --lzma "${=path_to_archive}" ;;
  (*.tar.zst|*.tzst) tar -cvf "${archive_name}" --use-compress-program="${_zstd_bin}" "${=path_to_archive}" ;;
  (*.tar) tar -cvf "${archive_name}" "${=path_to_archive}" ;;
  (*.zip|*.jar) zip -r "${archive_name}" "${=path_to_archive}" ;;
  (*.rar) rar a "${archive_name}" "${=path_to_archive}" ;;
  (*.7z) 7za a "${archive_name}" "${=path_to_archive}" ;;
  (*.gz) print "\n.gz is only useful for single files, and does not capture permissions. Use .tar.gz" ;;
  (*.bz2) print "\n.bzip2 is only useful for single files, and does not capture permissions. Use .tar.bz2" ;;
  (*.xz) print "\n.xz is only useful for single files, and does not capture permissions. Use .tar.xz" ;;
  (*.lzma) print "\n.lzma is only useful for single files, and does not capture permissions. Use .tar.lzma" ;;
  (*) print "\nunknown archive type for archive: ${archive_name}" ;;
esac

}
