## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A work-in-progress parametric flute modeling tool

# ~~~~~ legend ~~~~~
ℓ # distance to embouchure center (Z axis)
⌀ # bore diameter (XY plane)
ℎ # hole or wall height (Y axis in XY plane)
𝑑 # hole diameter or ellipse height (X axis in XZ plane)
𝑠 # hole ellipse width (Z axis in XZ plane)
𝜃 # hole rotation angle (°⦭ XY plane)
𝜓 # hole undercut angle (°⦮ XY plane)
𝜑 # hole shoulder-cut angle (°⦭ YZ plane)
𝑓 # frequency
ϑ # internal air temperature
# ~~ subscripts ~~
₀ # crown (z=0)
ᵣ # reflector
ₑ # embouchure
ₚ # lip-plate
ₛ # stationary point
ₕ # tone hole
ₙ # tenon start
ₐ # head-joint end
ₜ # flute end
₊ # extruder

# ----- head-joint -----
ℓ₀ # crown-embouchure distance
⌀₀ # crown inner diameter
ℎ₀ # crown wall height
ℓᵣ # reflector-embouchure length
⌀ᵣ # bore diameter at reflector
ℎᵣ # wall thickness at reflector
⌀ₚ # bore diameter under lip-plate
ℓₚ # lip plate edge distance
𝜃ₚ # lip plate rotation
ℓₑ # embouchure correction*
⌀ₑ # bore diameter at embouchure
ℎₑ # embouchure hole height
𝑑ₑ # embouchure hole length
𝑠ₑ # embouchure hole width
𝜓ₑ # embouchure undercut angle
𝜑ₑ # embouchure shoulder-cut angle
ℓₛ # bore taper stationary point
⌀ₛ # bore diameter at stationary
ℎₛ # flute wall @ stationary point
ℓₙ # tenon start
ℓₐ # embouchure-headjoint length

# ----- flute -----
𝑓ₜ # fundamental frequency
ℓₜ # bore length

# ----- per hole -----
𝑔  # interval ratio minus one
𝑓ₕ # frequency of hole
# ~~~
ℓₕ # embouchure-hole distance
⌀ₕ # bore diameter at tone hole
ℎₕ # tone hole height
𝑑ₕ # tone hole diameter
𝜃ₕ # tone hole rotation
𝜓ₕ # tone hole undercut

# ---- printing -----
ℓ₊ # layer height
⌀₊ # extruder bore diameter
