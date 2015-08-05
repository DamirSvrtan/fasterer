[1,2,3].include? 2

numbers = [1,2,3]

numbers.include? 2

def fast
  (BEGIN_OF_JULY..END_OF_JULY).cover? DAY_IN_JULY
end

def slow
  (BEGIN_OF_JULY..END_OF_JULY).include? DAY_IN_JULY
end

(10..1_000_000).include? 999

(BEGIN_OF_JULY...END_OF_JULY).include? DAY_IN_JULY
