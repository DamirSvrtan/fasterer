HASH = { :writing => :fast_ruby }

def slow
  HASH.fetch(:writing) { nil }
end

def slow
  HASH.fetch(:writing) { 1 }
end

def slow
  HASH.fetch(:writing) { "1" }
end

def slow
  HASH.fetch(:writing) { true }
end

def fast
  HASH.fetch(:writng, 1)
end

HASH.fetch(:writing)
