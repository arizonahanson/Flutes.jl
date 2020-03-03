export 𝐺
export note

𝐺 =2^(1/12)
function note(s::String, A₄=440.0)
  tone=Int(s[1])-65   # 'A'=0
  oct=Int(s[end])-48 # '0'=0
  semi = 2tone
  if tone >= 2 #C
    semi -= 1 # no B#
    oct -= 1 # oct at C
  end
  if tone >= 5 #F
    semi -= 1 # no E#
  end
  if length(s) == 3
    if s[2] == '♭'
      semi -= 1
    elseif s[2] == '♯'
      semi += 1
    end
  end
  return round(A₄/32 * 𝐺^semi * 2^(oct+1); digits=6)
end
