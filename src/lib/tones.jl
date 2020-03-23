export 𝐺
export note

𝐺 =2.0^(1.0/12.0)
function note(name::String, A₄=440.0)
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
  return round(A₄/16.0 * 𝐺^semitone * 2.0^octave; digits=6)
end
