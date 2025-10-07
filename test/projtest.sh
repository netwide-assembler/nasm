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

PROJ="$2"
PROJ_GET_BUILD="get_build_${PROJ}.sh"
if ! [ -f ${PROJ_GET_BUILD} ]; then
	echo 'No knowledge in building the project' 1>&2
	exit 1
fi

export PATH=${PWD}:$PATH

set -x

mkdir -p "${there}/${PROJ}"
cd "${there}/${PROJ}"
here="$(pwd)"

logfile="$here/test.log"
filelist="$here/file.list"
rm -f "$logfile"
export projnasm_logfile="$logfile"
export projnasm_filelist="$filelist"
export projnasm_nasm1="$NASM1"
export projnasm_nasm2="$NASM2"

source ../${PROJ_GET_BUILD}
rev=$?
if [ "$rev" -ne "0" ]; then
	echo ${PROJ} compiling failed ...
	exit $rev
fi

set +x

{
for x in $(grep -o -P "\-o .*\.o" $logfile | sed -e 's/-o //')
do
	if ! [ -f $x ]; then
		# probably it's a temporary assembly being tested
		continue
	fi
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

rev=$(! grep -e " does not exist" -e "\[differs\]" $here/results >/dev/null)

exit $rev
