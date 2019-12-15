
"""
Parametric Flute Modeler
"""
module Flutes

    """
        soundspeed(𝜗::Number=25.0)

    Calculate the speed of sound (m/s) in air of temperature 𝜗 (°C)
    """
    function soundspeed(𝜗::Number=25.0)
        𝛾 = 1.400            # heat capacity ratio of air
        𝑅 = 8.31446261815324 # molar gas constant (J/mol/K)
        𝑀 = 0.028965369      # mean molar mass of air (kg/mol)
        √(𝛾 * 𝑅/𝑀 * 273.15) * √(1 + 𝜗/273.15)
    end

    """
        wavelength(𝐹::Number=440.0, 𝜗::Number=25.0)

    Calculate the wavelength (m) of frequency 𝐹 (Hz) in air of temperature 𝜗 (°C)
    """
    function wavelength(𝐹::Number=440.0, 𝜗::Number=25.0)
        𝑐 = soundspeed(𝜗)
        𝑐/𝐹
    end
end
