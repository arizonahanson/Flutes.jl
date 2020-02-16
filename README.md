## Parametric Flute Modeling Tool
### Author: Isaac W Hanson
### License: MIT

A work-in-progress parametric flute modeling tool

# ~~~~~ legend ~~~~~
ℓ # distance from embouchure center (Z axis)
⌀ # diameter (Y axis in XY plane)
ℎ # height/thickness (Y axis in XY plane)
𝑑 # diameter or ellipse width (X axis in XZ plane)
𝑠 # ellipse length (Z axis in XZ plane)
𝜃 # rotation angle (∠ °XY plane)
𝜓 # undercut angle (∠ °XY plane)
𝜙 # shoulder-cut angle  (∠ °XY plane)
𝑓 # frequency
𝜗 # internal air temperature
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
⌀₀ # crown outer diameter
ℓᵣ # reflector-embouchure length
⌀ᵣ # bore diameter at reflector
ℎᵣ # wall thickness at reflector
⌀ₚ # bore diameter under lip-plate
ℓₚ # lip plate edge distance
𝜃ₚ # lip plate rotation
ℓₑ # correction to 1/2 wavelength
⌀ₑ # bore diameter at embouchure
ℎₑ # embouchure hole height
𝑑ₑ # embouchure hole length
𝑠ₑ # embouchure hole width
𝜓ₑ # embouchure undercut angle
𝜙ₑ # embouchure shoulder-cut angle
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
