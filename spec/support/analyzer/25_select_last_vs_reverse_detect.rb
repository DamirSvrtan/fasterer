def slow
  ARRAY.select { |x| (x % 10).zero? }.last
end

def fast
  ARRAY.reverse.detect { |x| (x % 10).zero? }
end
