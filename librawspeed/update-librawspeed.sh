#!/bin/bash

for i in */.git;do (cd ${i/.git/}; git pull);done
for i in */.svn;do (cd ${i/.svn/}; svn update);done
 
make -C RawSpeed
make -C LibRaw -f Makefile.devel
