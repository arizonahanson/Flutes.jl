export soundspeed, halfwavelength, wavenumber
export flutelength, toneholelength, closedholecorrection

"""
  𝑐 = soundspeed(ϑ=25.0)

Calculate the speed of sound in air of temperature ϑ in m/s
"""
function soundspeed(ϑ=25.0)
  𝛾 = 1.400            # heat capacity ratio of air
  𝑅 = 8.31446261815324 # molar gas constant (J/mol/K)
  𝑀 = 0.028965369      # mean molar mass of air (kg/mol)
  𝑐 = √(𝛾*𝑅/𝑀 *273.15)*√(1.0 + ϑ/273.15)
  return 𝑐
end

"""
  𝜔 = angularfreq(𝑓=440.0)

calculate angular frequency of 𝑓 in rad/s
"""
function angularfreq(𝑓=440.0)
  𝜔 = 2π*𝑓
  return 𝜔
end

"""
  𝑘 = wavenumber(𝑓=440.0; 𝜗=25.0)

calculate wavenumber of given frequency 𝑓 in air of temperature 𝜗 in m⁻¹
"""
function wavenumber(𝑓=440.0; ϑ=25.0)
  𝑐 = soundspeed(ϑ)
  𝜔 = angularfreq(𝑓)
  𝑘 = 𝜔/𝑐
  return 𝑘
end

"""
  𝜆 = halfwavelength(𝑓=440.0; ϑ=25.0)

calculate half-wavelength of given frequency 𝑓 in air of temperature ϑ
"""
function halfwavelength(𝑓=440.0; ϑ=25.0)
  𝑐 = soundspeed(ϑ)
  𝜆 = 𝑐/2𝑓
  return 1000𝜆 # (to mm)
end

"""
  ℓₜ = flutelength(𝑓=440.0; ϑ=25.0, ⌀=19.0, ℎ=3.5, 𝛥ℓₑ=57.0, 𝛥ℓᵥ=0.0)

Calculate flute length from embouchure-hole to open-end
  for fundamental frequency 𝑓, temperature ϑ, open-end bore diameter ⌀,
  wall thickness ℎ, embouchure correction 𝛥ℓₑ and closed-hole correction 𝛥ℓᵥ
"""
function flutelength(𝑓=440.0; ϑ=25.0, ⌀=19.0, ℎ=3.5, 𝛥ℓₑ=57.0, 𝛥ℓᵥ=0.0)
  𝜆 = halfwavelength(𝑓; ϑ=ϑ)
  ⌀₊ = ⌀ + 2ℎ
  ϖ = ⌀/⌀₊
  𝜍 = 0.6133⌀/2
  𝜚 = 0.8216⌀/2
  𝛥ℓₜ = 𝜚 + ϖ * (𝜍-𝜚) + 0.057ϖ * (1-ϖ ^5)
  ℓₜ = 𝜆 - 𝛥ℓₑ - 𝛥ℓᵥ - 𝛥ℓₜ
  return ℓₜ
end

"""
  ℓₕ = toneholelength(𝑓=440.0, 𝑓ₜ=415.305, 𝑑=9.0; ϑ=25.0, ⌀=19.0, ℎ=3.5, 𝛥ℓₑ=57.0, 𝛥ℓᵥ=0.0)

Calculate distance from embouchure hole center to tone hole center
  for open frequency 𝑓, closed frequency 𝑓ₜ, tone-hole diameter 𝑑,
  temperature ϑ, tone-hole bore diameter ⌀, tone-hole height ℎ,
  embouchure correction 𝛥ℓₑ and closed-hole correction 𝛥ℓᵥ
"""
function toneholelength(𝑓=440.0, 𝑓ₜ=415.305, 𝑑=9.0; ϑ=25.0, ⌀=19.0, ℎ=3.5, 𝛥ℓₑ=57.0, 𝛥ℓᵥ=0.0)
  𝜆 = halfwavelength(𝑓; ϑ=ϑ)
  𝑔 = 𝑓/𝑓ₜ - 1
  𝜙 = (ℎ+𝑑) * (⌀/𝑑)^2 - 0.45⌀
  𝑧 = 𝑔/2 * √(1 + 4𝜙/(𝑔*𝜆)) - 𝑔/2
  𝛥ℓₕ = 𝑧 * 𝜆
  ℓₕ = 𝜆 - 𝛥ℓₑ - 𝛥ℓᵥ - 𝛥ℓₕ
  return ℓₕ
end

"""
  𝛥𝜆ₕ = closedholecorrection(𝑓=440.0, 𝑓ₜ=415.305, 𝑑=9.0; ϑ=25.0, ⌀=19.0, ℎ=3.5, 𝛥ℓₑ=57.0, 𝛥ℓᵥ=0.0)

Calculate correction due to closed hole
  for open frequency 𝑓, closed frequency 𝑓ₜ, tone-hole diameter 𝑑,
  temperature ϑ, tone-hole bore diameter ⌀, tone-hole height ℎ,
  embouchure correction 𝛥ℓₑ and closed-hole correction 𝛥ℓᵥ
"""
function closedholecorrection(𝑓=440.0, 𝑓ₜ=415.305, 𝑑=9.0; ϑ=25.0, ⌀=19.0, ℎ=3.5, 𝛥ℓₑ=57.0, 𝛥ℓᵥ=0.0)
  𝑘 = wavenumber(𝑓; ϑ=ϑ)
  𝜆ₜ= halfwavelength(𝑓ₜ; ϑ=ϑ)
  ℓₕ = toneholelength(𝑓, 𝑓ₜ, 𝑑; ϑ=ϑ, ⌀=⌀, ℎ=ℎ, 𝛥ℓₑ=𝛥ℓₑ, 𝛥ℓᵥ=𝛥ℓᵥ)
  𝜙 = 𝑑^2*ℎ / ⌀^2
  ϵ = 2/π * atan(2𝑑/13ℎ)
  𝛿ₕ = 𝜆ₜ - 𝛥ℓₑ - ℓₕ
  𝛥𝜆ₕ = (sin(𝑘*𝛿ₕ)^2 - ϵ*cos(𝑘*𝛿ₕ)^2) * 𝜙
  return 𝛥𝜆ₕ
end
