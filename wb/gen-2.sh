#!/bin/bash

./extractwb-2.pl|sort -k 9 -k 1,1n -k 3,3n|uniq|./ufraw-tables-2.pl > wb.inc

