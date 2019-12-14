
"""
Parametric Flute Modeler
"""
module Flutes

    """
        soundspeed(𝜗::Number)

    calculate the speed of sound (m/s)
    in air of the given temperature 𝜗 (°C)
    """
    function soundspeed(𝜗::Number)
        𝛾 = 1.400            # heat capacity ratio of air
        𝑅 = 8.31446261815324 # molar gas constant (J/mol/K)
        𝑀 = 0.0289647        # mean molar mass of air (kg/mol)
        𝑐 = √(𝛾 * 𝑅/𝑀 * 273.15) * √(1 + 𝜗/273.15)
        round(𝑐; sigdigits=4)
    end
end
