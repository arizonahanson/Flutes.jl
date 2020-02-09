
"""
  Parametric Flute Modeling Tool

distances in millimeters
frequencies in Hertz
temperatures in Celsius
time in seconds
"""
module Flutes

export soundspeed, halfwavelength
export flutelength, toneholelength
export 𝐺

"""
  𝐺 = 2^(1/12)

The constant by which a frequency may be multiplied to result in a
  frequency one semitone higher, using equal temperament tuning.
"""
𝐺 = 2^(1/12)

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
  𝜑 = halfwavelength(𝑓=440.0, 𝜗=25.0)

calculate half of a wavelength of given frequency 𝑓 in air of temperature 𝜗
"""
function halfwavelength(𝑓=440.0, 𝜗=25.0)
  𝑐 = soundspeed(𝜗)
  𝜑 = 𝑐/2𝑓
  round(𝜑; sigdigits=6)
end

"""
  ℓₜ = flutelength(;𝑓=261.615565, 𝜗=25.0, ℓᵩ=52.0, ⌀=19.0)

Calculate flute length from embouchure-hole to open-end
  for fundamental frequency 𝑓, temperature 𝜗, embouchure correction ℓᵩ,
  and open-end bore diameter ⌀
"""
function flutelength(𝑓=261.615565; 𝜗=25.0, ℓᵩ=52.0, ⌀=19.0)
  𝜑 = halfwavelength(𝑓, 𝜗)
  𝛥ℓₜ = 0.3⌀
  ℓₜ = 𝜑 - ℓᵩ - 𝛥ℓₜ
  round(ℓₜ; digits=2)
end

"""
  ℓₕ = toneholelength(;𝑓=440, 𝜗=25.0, ℓᵩ=52.0, ⌀=19.0, ℎ=2.5, 𝑑=7, 𝑔=(𝐺 - 1))

Calculate distance from embouchure hole center to tone hole center
  for supplied frequency 𝑓, temperature 𝜗, embouchure correction ℓᵩ,
  tone-hole bore diameter ⌀, tone-hole height ℎ, tone-hole diameter 𝑑,
  and interval coefficient 𝑔
"""
function toneholelength(𝑓=440; 𝜗=25.0, ℓᵩ=52.0, ⌀=19.0, ℎ=2.5, 𝑑=7, 𝑔=(𝐺 - 1))
  𝜑 = halfwavelength(𝑓, 𝜗)
  𝐿 = (ℎ+𝑑) * (⌀/𝑑)^2 - 0.45⌀
  𝑧 = 𝑔/2 * √(1 + 4𝐿/(𝑔*𝜑)) - 𝑔/2
  𝛥ℓₕ = 𝑧*𝜑
  ℓₕ = 𝜑 - ℓᵩ - 𝛥ℓₕ
  round(ℓₕ; digits=2)
end
end
