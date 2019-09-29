#!/bin/bash

# Read all but the apply_oracle_lab2.sql file and rename them.
for i in $(ls *[^2].sql); do
  mv $i ${i/./_lab.}
done
