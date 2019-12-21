
"""
Parametric Flute Modeler

distances in millimeters
frequencies in Hertz
temperatures in Celsius (default 25.0°C)
time in seconds
"""
module Flutes
    export soundspeed, wavelength

    """
        𝑐 = soundspeed(𝜗::Number=25.0)

    Calculate the speed of sound in air of temperature 𝜗
    """
    function soundspeed(𝜗::Number=25.0)
        𝛾 = 1.400            # heat capacity ratio of air
        𝑅 = 8.31446261815324 # molar gas constant (J/mol/K)
        𝑀 = 0.028965369      # mean molar mass of air (kg/mol)
        √(𝛾 * 𝑅/𝑀 * 273.15) * √(1.0 + 𝜗/273.15) * 1000.0
    end

    """
        𝜆₁ = wavelength(𝐹::Number=261.6255653, 𝜗::Number=25.0)

    Calculate the wavelength of frequency 𝐹 in air of temperature 𝜗
    """
    function wavelength(𝐹::Number=261.6255653, 𝜗::Number=25.0)
        𝑐 = soundspeed(𝜗)
        𝑐/𝐹
    end
end
