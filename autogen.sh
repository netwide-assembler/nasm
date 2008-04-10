#!/bin/sh -xe
#
# Simple script to run the appropriate autotools from a repository.
#
autoheader
autoconf
rm -rf autom4te.cache config.log config.status
