
"""
  Parametric Flute Modeling Tool

distances in millimeters
frequencies in Hertz
temperatures in Celsius
time in seconds
"""
module Flutes

include("Notes.jl")
export soundspeed, wavelength
export flutelength, toneholelength

"""
  𝑐 = soundspeed(𝜗=25.0)

Calculate the speed of sound in air of temperature 𝜗
"""
function soundspeed(𝜗=25.0)
  𝛾 = 1.400            # heat capacity ratio of air
  𝑅 = 8.31446261815324 # molar gas constant (J/mol/K)
  𝑀 = 0.028965369      # mean molar mass of air (kg/mol)
  𝑐 = √(𝛾*𝑅/𝑀 *273.15)*√(1.0 + 𝜗/273.15)
  round(𝑐; sigdigits=6)*1000.0 # (to mm/s)
end

"""
  𝜆 = wavelength(𝑓=A₄, 𝜗=25.0)

calculate wavelength of given frequency 𝑓 in air of temperature 𝜗
"""
function wavelength(𝑓=A₄, 𝜗=25.0)
  𝑐 = soundspeed(𝜗)
  𝜆 = 𝑐/𝑓
  round(𝜆; sigdigits=6)
end

"""
  ℓₜ = flutelength(;𝑓=C₄, 𝜗=25.0, ℓₑ=52.0, ⌀=19.0)

Calculate flute length from embouchure-hole to open-end
  for fundamental frequency 𝑓, temperature 𝜗, embouchure correction ℓₑ,
  and open-end bore diameter ⌀
"""
function flutelength(𝑓=C₄; 𝜗=25.0, ℓₑ=52.0, ⌀=19.0)
  𝛬 = wavelength(𝑓, 𝜗)/2
  𝛥ℓₜ = 0.3⌀
  ℓₜ = 𝛬 - ℓₑ - 𝛥ℓₜ
  round(ℓₜ; digits=2)
end

"""
  ℓₕ = toneholelength(;𝑓=A₄, 𝜗=25.0, ℓₑ=52.0, ⌀=19.0, ℎ=2.5, 𝑑=7, 𝑔=(𝐺 - 1))

Calculate distance from embouchure hole center to tone hole center
  for supplied frequency 𝑓, temperature 𝜗, embouchure correction ℓₑ,
  tone-hole bore diameter ⌀, tone-hole height ℎ, tone-hole diameter 𝑑,
  and interval coefficient 𝑔
"""
function toneholelength(𝑓=A₄; 𝜗=25.0, ℓₑ=52.0, ⌀=19.0, ℎ=2.5, 𝑑=7, 𝑔=(𝐺 - 1))
  𝛬 = wavelength(𝑓, 𝜗)/2
  𝐿 = (ℎ+𝑑) * (⌀/𝑑)^2 - 0.45⌀
  𝑧 = 𝑔/2 * √(1 + 4𝐿/(𝑔*𝛬)) - 𝑔/2
  𝛥ℓₕ = 𝑧*𝛬
  ℓₕ = 𝛬 - ℓₑ - 𝛥ℓₕ
  round(ℓₕ; digits=2)
end
end
