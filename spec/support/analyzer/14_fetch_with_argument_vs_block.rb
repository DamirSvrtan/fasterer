HASH = { :writing => :fast_ruby }

def slow
  HASH.fetch(:writing, [*1..100])
end

def fast
  HASH.fetch(:writing) { [*1..100] }
end

HASH.fetch(:writing)
