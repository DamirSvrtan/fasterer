ARRAY = (1..100).to_a

ARRAY.map { |e| [e, e] }.flatten(1)

ARRAY.map { |e| [e, e] }.flatten

ARRAY.map do |e|
  [e, e]
end.flatten

ARRAY.map do |e|
  [e, e]
end.flatten(1)

ARRAY.flat_map { |e| [e, e] }
