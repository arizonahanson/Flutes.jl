
"""
Parametric Flute Modeling Tool

distances in millimeters
frequencies in Hertz
temperatures in Celsius
time in seconds
"""
module Flutes
    export Flute, createFlute, tubelength

    mutable struct Flute
        𝐹   # Fundamental frequency       (261.6155653)
        𝜗   # Air temperature             (25.0)
        𝑑ₜ  # End tube bore diameter      (19.0)
        𝑑₀  # Bore diameter at embouchure (17.4)
        𝑑ₑ  # Embouchure diameter         (10.95)
        ℓₑ  # Embouchure height           (4.3)
        𝛥ℓₑ # Embouchure correction       (52.0)
    end

    """
        flute = createFlute(𝐹=261.6155653, 𝜗=25.0, 𝑑ₜ=19.0, 𝑑₀=17.4, 𝑑ₑ=10.95, ℓₑ=4.3, 𝛥ℓₑ=52.0)
    """
    function createFlute(𝐹=261.6155653, 𝜗=25.0, 𝑑ₜ=19.0, 𝑑₀=17.4, 𝑑ₑ=10.95, ℓₑ=4.3, 𝛥ℓₑ=52.0)
        return Flute(𝐹, 𝜗, 𝑑ₜ, 𝑑₀, 𝑑ₑ, ℓₑ, 𝛥ℓₑ)
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

    """
        function tubelength(flute::Flute)

    Calculate tube length from embouchure-hole to open-end for supplied flute struct
    """
    function tubelength(flute::Flute)
        𝑐 = soundspeed(flute.𝜗)
        𝜆₁ = 2 * flute.𝐹
        𝐿ₛ = 𝑐/𝜆₁
        ℓₜ = 𝐿ₛ - flute.𝛥ℓₑ - (0.3 * flute.𝑑ₜ)
        round(ℓₜ; digits=2)
    end
end
