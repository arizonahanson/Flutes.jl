## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A work-in-progress parametric flute modeling tool

FOOT_LENGTH=26
FOOT_HOLES=[]
BODY_LENGTH=26
BODY_HOLES=[]

# examples
make all ARGS='-D$fl=0.2'

make head ARGS='-D$fd=0.4 -D$fl=0.162'
make foot ARGS='-DFOOT_LENGTH=42'
make body ARGS='-DBODY_HOLES=[[8,21]]'
