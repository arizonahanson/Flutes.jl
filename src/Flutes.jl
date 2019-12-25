
"""
Parametric Flute Modeling Tool

distances in millimeters
frequencies in Hertz
temperatures in Celsius (default 25.0°C)
time in seconds
"""
module Flutes
    export Flute, soundspeed, wavelength, tubelength

    struct Flute
        𝐹::Number
        𝜗::Number
        𝑑ₜ::Number
    end

    """
        𝑐 = soundspeed(𝜗::Number=25.0)

    Calculate the speed of sound in air of temperature 𝜗
    """
    function soundspeed(𝜗::Number=25.0)
        𝛾 = 1.400            # heat capacity ratio of air
        𝑅 = 8.31446261815324 # molar gas constant (J/mol/K)
        𝑀 = 0.028965369      # mean molar mass of air (kg/mol)
        𝑐 = √(𝛾 * 𝑅/𝑀 * 273.15) * √(1.0 + 𝜗/273.15)
        round(𝑐; sigdigits=4) * 1000.0 # (to mm/s)
    end

    """
        temperature_at(𝑥::Number=0.0)

    Temperature at 𝑥 distance from embouchure: Coltman (1968)
    """
    function temperature_at(𝑥::Number=0.0)
        𝑇 = 30.3 - .0077𝑥
        round(𝑇; sigdigits=3)
    end

    """
        embouchurecorrection()

    Correction of tube-length at embouchure
    """
    function embouchurecorrection()
        𝛥ℓₑ = 52.0
    end

    """
        endcorrection(𝑑ₜ::Number=19.0)

    Correction of tube-length at open-end
    """
    function endcorrection(𝑑ₜ::Number=19.0)
        𝛥ℓₜ = 0.3𝑑ₜ
    end

    """
        tubelength(𝐹::Number=261.6155653, 𝜗::Number=25.0, 𝑑ₜ::Number=19.0)

    Calculate tube length from embouchure-hole to open-end for fundamental frequency 𝐹,
    with air temperature 𝜗 and open-end diameter 𝑑ₜ
    """
    function tubelength(𝐹::Number=261.6155653, 𝜗::Number=25.0, 𝑑ₜ::Number=19.0)
        𝑐 = soundspeed(𝜗)
        𝐿ₛ = 𝑐/2𝐹
        𝛥ℓₑ = embouchurecorrection()
        𝛥ℓₜ = endcorrection(𝑑ₜ)
        ℓₜ = 𝐿ₛ - 𝛥ℓₑ - 𝛥ℓₜ
        round(ℓₜ; digits=2)
    end
end
