#!/bin/bash -

there="$(realpath "$(dirname "$0")")"

[ -z "$NASM1" ] && NASM1=nasm
NASM1=$(which "$NASM1" 2>/dev/null)
if [ -z "$NASM1" ]; then
	echo 'Please install a reference nasm ...' 1>&2
	exit 1
fi
NASM2="$1"
[ -z "$NASM2" ] && NASM2=../nasm
NASM2=$(which "$NASM2" 2>/dev/null)

if [ -z "$NASM2" ]; then
    echo 'Test nasm not found' 1>&2
    exit 1
fi

set -x

mkdir -p "${there}/ffmpegtest"
cd "${there}/ffmpegtest"
here="$(pwd)"

logfile="$here/test.log"
filelist="$here/file.list"
rm -f "$logfile"
export ffmpegnasm_logfile="$logfile"
export ffmpegnasm_filelist="$filelist"
export ffmpegnasm_nasm1="$NASM1"
export ffmpegnasm_nasm2="$NASM2"

ffmpegnasm="$(realpath "$there/ffmpegnasm.sh")"

: >> "$filelist"

if [ -d ffmpeg/.git ]; then
    cd ffmpeg
    git reset --hard
    xargs -r rm -f < "$filelist"
else
    git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
    cd ffmpeg
fi
: > "$filelist"
./configure --disable-stripping --x86asmexe="$ffmpegnasm"
ncpus=$(ls -1 /sys/bus/cpu/devices | wc -l)
make -j${ncpus}
rev=$?
if [ "$?" -ne "0" ]; then
	echo ffmpeg compiling failed ...
	exit $rev
fi

set +x

{
for x in $(grep -o -P "\-o .*\.o" $logfile | sed -e 's/-o //' | grep -v "/ffconf")
do
	if ! [ -f ${x}.1 ]; then
		echo file ${x}.1 does not exist
	fi

	if ! [ -f ${x}.2 ]; then
		echo file ${x}.2 does not exist
	fi

	objdump -d ${x}.1 | tail -n +4 >/tmp/1.dump
	objdump -d ${x}.2 | tail -n +4 >/tmp/2.dump
	if ! diff /tmp/1.dump /tmp/2.dump >/dev/null; then
		echo [differs] $x
		#diff /tmp/1.dump /tmp/2.dump
	else
		echo [matches] $x
	fi
	rm -f /tmp/1.dump /tmp/2.dump
done
} | tee "$here/results"

rev=$(grep -e " does not exist" -e "\[differs\]" $here/results >/dev/null)

exit $rev
