[*0..100].find {|number| number > 77}
[*0..100].find do |number|
  number > 77
end
