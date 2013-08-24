#!/bin/bash

# sort collected values by 1)Vendor+Model 2)FakeTemperature 3)WBFinetune

./extractwb-2.pl|sort -k 9 -k 1,1n -k 3,3n|uniq|./ufraw-tables-2.pl > wb.inc

