#!/usr/bin/bash
script_PROGNAME=compress.sh
script_VERSION=2.0
script_COPYRIGHT_YEARS='2005, 2009, 2018'
script_AUTHOR='Marco Maggi'
script_LICENSE=GPL
script_USAGE="usage: ${script_PROGNAME} [options] FILE ..."
script_DESCRIPTION='Example script to compress files.'
script_EXAMPLES="Usage examples:
\t${script_PROGNAME} --compress file.ext\t\t;# 'file.ext' -> 'file.ext.gz'
\t${script_PROGNAME} --decompress file.ext.gz\t;# 'file.ext.gz' -> 'file.ext'
\t${script_PROGNAME} --bzip --stdout --compress file.ext >file.ext.bz2"
declare mbfl_INTERACTIVE=no
declare mbfl_LOADED=no
declare mbfl_HARDCODED=
declare mbfl_INSTALLED=$(type -p mbfl-config &>/dev/null && mbfl-config) &>/dev/null
declare item
for item in "$MBFL_LIBRARY" "$mbfl_HARDCODED" "$mbfl_INSTALLED"
do
if test -n "$item" -a -f "$item" -a -r "$item"
then
if source "$item" &>/dev/null
then break
else
printf '%s error: loading MBFL file "%s"\n' "$script_PROGNAME" "$item" >&2
exit 100
fi
fi
done
unset -v item
if test "$mbfl_LOADED" != yes
then
printf '%s error: incorrect evaluation of MBFL\n' "$script_PROGNAME" >&2
exit 100
fi
mbfl_declare_option ACTION_COMPRESS yes '' compress noarg "selects compress action"
mbfl_declare_option ACTION_DECOMPRESS no '' decompress noarg "selects decompress action"
mbfl_declare_option GZIP no G gzip noarg "selects gzip"
mbfl_declare_option BZIP no B bzip noarg "selects bzip2"
mbfl_declare_option LZIP no L lzip noarg "selects lzip"
mbfl_declare_option XZ   no X xz   noarg "selects xc"
mbfl_declare_option AUTO yes A auto noarg "automatically select compressor"
mbfl_declare_option KEEP no k keep noarg "keeps the original file"
mbfl_declare_option STDOUT no '' stdout noarg "writes output to stdout"
mbfl_declare_option GO_ON no '' go-on noarg "try to ignore errors when processing multiple files"
mbfl_file_enable_compress
mbfl_file_enable_listing
mbfl_file_enable_stat
mbfl_main_declare_exit_code 2 error_compressing
mbfl_main_declare_exit_code 3 error_decompressing
mbfl_main_declare_exit_code 4 wrong_command_line_arguments
function script_option_update_gzip () {
mbfl_file_compress_select_gzip
script_option_AUTO=no
}
function script_option_update_bzip () {
mbfl_file_compress_select_bzip2
script_option_AUTO=no
}
function script_option_update_lzip () {
mbfl_file_compress_select_lzip
script_option_AUTO=no
}
function script_option_update_xz () {
mbfl_file_compress_select_xz
script_option_AUTO=no
}
function script_option_update_keep () {
mbfl_file_compress_keep
}
function script_option_update_stdout () {
mbfl_file_compress_stdout
}
function script_before_parsing_options () {
mbfl_file_compress_nokeep
}
function script_action_compress () {
local item size
if ! mbfl_argv_all_files
then exit_because_wrong_command_line_arguments
fi
for item in "${ARGV[@]}"
do
if test "$script_option_AUTO" = 'yes'
then
mbfl_file_get_size_var size "$item"
if ((size > 10000000))
then mbfl_file_compress_select_bzip
else mbfl_file_compress_select_gzip
fi
fi
if ! mbfl_file_compress "$item"
then
# After an error compressing a  file: what should we do?  Go
# on with the next file or exit?
if test "$script_option_GO_ON" = yes
then mbfl_message_warning_printf 'unable to successfully compress "%s"' "$item"
else
mbfl_message_error_printf 'unable to successfully compress "%s"' "$item"
exit_because_error_compressing
fi
else mbfl_message_verbose_printf 'successfully compressed "%s"\n' "$item"
fi
done
exit_success
}
function script_action_decompress () {
local item ext
if ! mbfl_argv_all_files
then exit_because_wrong_command_line_arguments
fi
for item in "${ARGV[@]}"
do
mbfl_file_extension_var ext "$item"
case "${ext}" in
gz)
mbfl_file_compress_select_gzip
;;
bz2)
mbfl_file_compress_select_bzip
;;
lz)
mbfl_file_compress_select_lzip
;;
xz)
mbfl_file_compress_select_xz
;;
*)
mbfl_message_warning_printf 'unknown compressor extension: "%s"' "$ext"
continue
;;
esac
if ! mbfl_file_decompress "$item"
then
# After an  error decompressing a  file: what should  we do?
# Go on with the next file or exit?
if test "$script_option_GO_ON" = yes
then mbfl_message_warning_printf 'unable to successfully decompress "%s"' "$item"
else
mbfl_message_error_printf 'unable to successfully decompress "%s"' "$item"
exit_because_error_compressing
fi
fi
done
exit_success
}
mbfl_main
