
"""
Parametric Flute Modeling Tool

distances in millimeters
frequencies in Hertz
temperatures in Celsius
time in seconds
"""
module Flutes
    export Flute, createFlute, tubelength, holelength
    include("apply.jl")

    mutable struct Flute
        𝑓ₜ  # Fundamental frequency       (261.6155653)
        𝜗   # Air temperature             (25.0)
        ⌀ₔ  # stop taper bore diameter    (19.0)
        ⌀ₜ  # flute end bore diameter     (19.0)
        𝛥ℓᵩ # Embouchure correction       (52.0)
    end

    """
        flute = createFlute(𝑓ₜ=261.6155653, 𝜗=25.0, ⌀ₔ=19.0, ⌀ₜ=19.0, 𝛥ℓᵩ=52.0)
    """
    function createFlute(𝑓ₜ=261.6155653, 𝜗=25.0, ⌀ₔ=19.0, ⌀ₜ=19.0, 𝛥ℓᵩ=52.0)
        return Flute(𝑓ₜ, 𝜗, ⌀ₔ, ⌀ₜ, 𝛥ℓᵩ)
    end

    """
        𝑐 = soundspeed(𝜗=25.0)

    Calculate the speed of sound in air of temperature 𝜗
    """
    function soundspeed(𝜗=25.0)
        𝛾 = 1.400            # heat capacity ratio of air
        𝑅 = 8.31446261815324 # molar gas constant (J/mol/K)
        𝑀 = 0.028965369      # mean molar mass of air (kg/mol)
        𝑐 = √(𝛾 * 𝑅/𝑀 * 273.15) * √(1.0 + 𝜗/273.15)
        round(𝑐; sigdigits=4) * 1000.0 # (to mm/s)
    end

    """
      𝜑 = halfwavelength(𝑓=440.0, 𝜗=25.0)

    calculate half of a wavelength of given frequency 𝑓 in air of temperature 𝜗
    """
    function halfwavelength(𝑓=440.0, 𝜗=25.0)
        𝑐 = soundspeed(𝜗)
        𝜑 = 𝑐/2𝑓
        round(𝜑; digits=6)
    end

    """
        ℓₜ = tubelength(flute::Flute)

    Calculate tube length from embouchure-hole to open-end for supplied flute struct
    """
    function tubelength(flute::Flute)
        𝜑 = halfwavelength(flute.𝑓ₜ, flute.𝜗)
        𝛥ℓₜ = 0.3 * flute.⌀ₜ
        ℓₜ = 𝜑 - flute.𝛥ℓᵩ - 𝛥ℓₜ
        round(ℓₜ; digits=2)
    end

    """
    ℓₕ = holelength(flute::Flute, 𝑓ₕ=440, ℎₕ=2.5, 𝑑ₕ=7, ⌀ₕ=19.0, 𝑔=2^(1/12)-1)

    Calculate distance from embouchure hole center to tone hole center for supplied frequency 𝑓ₕ,
      tone hole height ℎₕ, tone hole diameter 𝑑ₕ, bore diameter ⌀ₕ and interval ratio 𝑔 (minus one)
    """
    function holelength(flute::Flute, 𝑓ₕ=440, ℎₕ=2.5, 𝑑ₕ=7, ⌀ₕ=19.0, 𝑔=2^(1/12)-1)
        𝜑 = halfwavelength(𝑓ₕ, flute.𝜗)
        𝐿ₕ = (ℎₕ + 𝑑ₕ) * (⌀ₕ/𝑑ₕ)^2 - 0.45⌀ₕ
        𝑧 = 𝑔/2 * √(1 + 4𝐿ₕ/(𝑔*𝜑)) - 𝑔/2
        𝛥ℓₕ = 𝑧 * 𝜑
        ℓₕ = 𝜑 - flute.𝛥ℓᵩ - 𝛥ℓₕ
        round(ℓₕ; digits=2)
    end
end
