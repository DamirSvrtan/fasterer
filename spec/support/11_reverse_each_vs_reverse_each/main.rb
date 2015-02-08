ARRAY = (1..100).to_a

ARRAY.reverse.each{|x| x}

ARRAY.reverse_each{|x| x}

ARRAY.reverse.each do |x|
  x
end
