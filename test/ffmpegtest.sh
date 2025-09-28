#!/bin/bash

if ! which nasm 2>&1 >/dev/null; then
	echo Please install nasm ...
	exit 1
fi

NASM1=$(which nasm)
NASM2=${PWD}/../nasm

rm -rf sandbox
mkdir sandbox
cd sandbox

export PATH=${PWD}:$PATH

logfile=$(mktemp /tmp/nasmXXXXXXXX.log)

cat >nasm <<EOF
#!/bin/bash

PARAM_MOD1=\$(echo \$@ | sed 's/\.o /.o.1 /')
PARAM_MOD2=\$(echo \$@ | sed 's/\.o /.o.2 /')
echo "\$@" >> $logfile
${NASM1} \${PARAM_MOD1}
${NASM2} \${PARAM_MOD2}
${NASM1} \$@
EOF
chmod a+x nasm

git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
./configure
make -j
rev=$?
if [ "$?" -ne "0" ]; then
	echo ffmpeg compiling failed ...
	exit $rev
fi

for x in $(grep -o -P "\-o .*\.o" $logfile | sed -e 's/-o //' | grep -v "/ffconf")
do
	if ! [ -f ${x}.1 ]; then
		echo file ${x}.1 does not exist
		rev=1
	fi

	if ! [ -f ${x}.2 ]; then
		echo file ${x}.2 does not exist
		rev=1
	fi

	objdump -d ${x}.1 | tail -n +4 >/tmp/1.dump
	objdump -d ${x}.2 | tail -n +4 >/tmp/2.dump
	if ! diff /tmp/1.dump /tmp/2.dump >/dev/null; then
		echo [differs] $x
		#diff /tmp/1.dump /tmp/2.dump
		rev=1
	else
		echo [matches] $x
	fi
	rm -f /tmp/1.dump /tmp/2.dump
done

rm $logfile

exit $rev
