#!/bin/bash
declare -a param1
declare -a param2
for p; do
    case "$p" in
	*.o) ofile="$p"
	     param1+=("$p.1" '-l' "$p.lst.1")
	     param2+=("$p.2" '-l' "$p.lst.2")
	     printf '%s\n%s.2\n%s.lst.2\n' "$ofile" "$ofile" "$ofile" \
		    >> "$ffmpegnasm_filelist"
	     ;;
	*)   param1+=("$p")
	     param2+=("$p")
	     ;;
    esac
done

printf '%s\n' "$*" >> "$ffmpegnasm_logfile"

rm -f "$ofile"
"$ffmpegnasm_nasm1" "${param1[@]}" || exit $?
"$ffmpegnasm_nasm2" "${param2[@]}" || exit $?
cp -f "$ofile.1" "$ofile"
