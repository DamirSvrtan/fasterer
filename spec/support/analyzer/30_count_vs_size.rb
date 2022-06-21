ARRAY = (0..100).to_a

ARRAY.count

ARRAY.map do |x|
    x * 2
end.count

ARRAY.select { |x| x % 2 == 0 }.count

ARRAY.count(2) # ok
ARRAY.count(&:positive?) # ok
