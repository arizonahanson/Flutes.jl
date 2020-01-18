
"""
Parametric Flute Modeling Tool

distances in millimeters
frequencies in Hertz
temperatures in Celsius
time in seconds
"""
module Flutes
    export Flute, createFlute, tubelength, holelength

    mutable struct Flute
        𝐹   # Fundamental frequency       (261.6155653)
        𝜗   # Air temperature             (25.0)
        𝑑ₜ  # End tube bore diameter      (19.0)
        𝛥ℓₑ # Embouchure correction       (52.0)
    end

    """
        flute = createFlute(𝐹=261.6155653, 𝜗=25.0, 𝑑ₜ=19.0, 𝛥ℓₑ=52.0)
    """
    function createFlute(𝐹=261.6155653, 𝜗=25.0, 𝑑ₜ=19.0, 𝛥ℓₑ=52.0)
        return Flute(𝐹, 𝜗, 𝑑ₜ, 𝛥ℓₑ)
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
        temperature_at(𝑥=0.0)

    Temperature at 𝑥 distance from embouchure: Coltman (1968)
    """
    function temperature_at(𝑥=0.0)
        𝑇 = 30.3 - .0077𝑥
        round(𝑇; sigdigits=3)
    end

    function halfwavelength(𝜗=25.0, 𝐹=440)
        𝑐 = soundspeed(𝜗)
        𝐿ₛ = 𝑐/2𝐹
    end

    """
        function tubelength(flute::Flute)

    Calculate tube length from embouchure-hole to open-end for supplied flute struct
    """
    function tubelength(flute::Flute)
        𝐿ₛ = halfwavelength(flute.𝜗, flute.𝐹)
        𝛥ℓₜ = 0.3 * flute.𝑑ₜ
        ℓₜ = 𝐿ₛ - flute.𝛥ℓₑ - 𝛥ℓₜ
        round(ℓₜ; digits=2)
    end

    function holelength(flute::Flute, 𝐹=440, ℓₕ=1.0, 𝑑ₕ=7, 𝑑₁=19.0, 𝑔=2^(1/12)-1)
        𝐿ₛ = halfwavelength(flute.𝜗, 𝐹)
        𝐿ₕ = (ℓₕ + 𝑑ₕ) * (𝑑₁ / 𝑑ₕ)^2 - 0.45𝑑₁
        𝑧 = 𝑔/2 * √(1 + 4𝐿ₕ/(𝑔 * 𝐿ₛ)) - 𝑔/2
        𝛥ℓₕ = 𝑧 * 𝐿ₛ
        ℓₗ = 𝐿ₛ - flute.𝛥ℓₑ - 𝛥ℓₕ
        round(ℓₗ; digits=2)
    end
end
