#!/bin/bash

./extractwb-2.pl|sort -k 1,1n -k 3,3n|uniq|./ufraw-tables-2.pl > wb-d800e.inc
sed 's/D800E/D800/' wb-d800e.inc > wb-d800.inc
cat wb-d800.inc wb-d800e.inc |tee wb-all-d800.inc

