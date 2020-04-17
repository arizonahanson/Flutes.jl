export soundspeed, wavelength, wavenumber
export flutelength, toneholelength, closedholecorrection

"""
  𝑐 = soundspeed(ϑ=25.0)

Calculate the speed of sound in air of temperature ϑ
"""
function soundspeed(ϑ=25.0)
  𝛾 = 1.400            # heat capacity ratio of air
  𝑅 = 8.31446261815324 # molar gas constant (J/mol/K)
  𝑀 = 0.028965369      # mean molar mass of air (kg/mol)
  𝑐 = √(𝛾*𝑅/𝑀 *273.15)*√(1.0 + ϑ/273.15)
  return 𝑐*1000.0 # (to mm/s)
end

"""
  𝜆 = wavelength(𝑓=440.0; ϑ=25.0)

calculate wavelength of given frequency 𝑓 in air of temperature ϑ
"""
function wavelength(𝑓=440.0; ϑ=25.0)
  𝑐 = soundspeed(ϑ)
  𝜆 = 𝑐/𝑓
  return 𝜆
end

"""
  𝑘 = wavenumber(𝑓=440.0; 𝜗=25.0)

calculate wavenumber of given frequency 𝑓 in air of temperature 𝜗
"""
function wavenumber(𝑓=440.0; ϑ=25.0)
  𝑐 = soundspeed(ϑ)
  𝑘 = 2π*𝑓/𝑐
  return 𝑘
end

"""
  ℓₜ = flutelength(𝑓=440.0; ϑ=25.0, ℓₑ=52.0, ⌀=19.0)

Calculate flute length from embouchure-hole to open-end
  for fundamental frequency 𝑓, temperature ϑ, embouchure correction ℓₑ,
  and open-end bore diameter ⌀
"""
function flutelength(𝑓=440.0; ϑ=25.0, ℓₑ=52.0, ⌀=19.0)
  𝛬 = wavelength(𝑓; ϑ=ϑ)/2
  𝛥ℓₜ = 0.3⌀
  ℓₜ = 𝛬 - ℓₑ - 𝛥ℓₜ
  return ℓₜ
end

"""
𝛥ℓ = closedholecorrection(𝑓=440.0; ϑ=25.0, ⌀=19.0, 𝑑=9.0, ℎ=3.5, ℓ𝑟=0.0)

calculate correction due to closed hole
"""
function closedholecorrection(𝑓=440.0; ϑ=25.0, ⌀=19.0, 𝑑=9.0, ℎ=3.5, ℓ𝑟=0.0)
  ϵ = 2/π * atan(2𝑑/13ℎ)
  𝑘 = wavenumber(𝑓; ϑ=ϑ)
  𝑉 = π*𝑑^2*ℎ
  𝑆 = π*⌀^2
  𝛥ℓ = (sin(𝑘*ℓ𝑟)^2 - ϵ*cos(𝑘*ℓ𝑟)^2) * 𝑉/𝑆
  return 𝛥ℓ
end

"""
ℓₕ = toneholelength(𝑓=440.0; ϑ=25.0, ℓₑ=52.0, ⌀=19.0, 𝑑=9.0, ℎ=3.5, 𝑔=2^(1/12))

Calculate distance from embouchure hole center to tone hole center
  for supplied frequency 𝑓, temperature ϑ, embouchure correction ℓₑ,
  tone-hole bore diameter ⌀, tone-hole height ℎ, tone-hole diameter 𝑑
"""
function toneholelength(𝑓=440.0; ϑ=25.0, ℓₑ=52.0, ⌀=19.0, 𝑑=9.0, ℎ=3.5)
  𝑔 = 2^(1/12) - 1
  𝛬 = wavelength(𝑓; ϑ=ϑ)/2
  𝐿 = (ℎ+𝑑) * (⌀/𝑑)^2 - 0.45⌀
  𝑧 = 𝑔/2 * √(1 + 4𝐿/(𝑔*𝛬)) - 𝑔/2
  𝛥ℓₕ = 𝑧 * 𝛬
  ℓₕ = 𝛬 - ℓₑ - 𝛥ℓₕ
  return ℓₕ
end
