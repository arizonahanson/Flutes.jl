export tone

"""
𝑓 = tone(name; A=440.0)
  convert tone name to frequency, equal temperament
    tone("A4")
    tone("C♭0")
    tone("B♯9")
"""
function tone(name; A=440.0)
  𝑔=2^(1/12)
  wholetone=Int(name[1])-65   # 'A'=0
  octave=Int(name[end])-48 # '0'=0
  semitone = 2*wholetone
  if wholetone >= 2 #C
    semitone -= 1 # no B♯
    octave -= 1 # octave at C
  end
  if wholetone >= 5 #F
    semitone -= 1 # no E♯
  end
  if length(name) == 3
    if name[2] in ['♭', 'b']
      semitone -= 1
    elseif name[2] in ['♯', '#']
      semitone += 1
    end
  end
  return round(A/16.0 * 𝑔^semitone * 2.0^octave; digits=6)
end
