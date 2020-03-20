## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A work-in-progress parametric flute modeling tool

FOOT_LEN=26
FOOT_HOLES=[]
BODY_LEN=26
BODY_HOLES=[]

# examples
make all ARGS='-D$fl=0.2'

make head ARGS='-D$fd=0.4 -D$fl=0.162'
make foot ARGS='-DFOOT_LEN=42'
make body ARGS='-DBODY_HOLES=[[8,21]]'
