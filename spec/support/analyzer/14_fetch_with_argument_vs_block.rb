HASH = { :writing => :fast_ruby }

def slow
  HASH.fetch(:writing, [*1..100])
end

def fast
  HASH.fetch(:writing) { [*1..100] }
end

def fast_with_symbol
  HASH.fetch(:writing, :fast)
end

def fast_with_boolean
  HASH.fetch(:writing, true)
end

def fast_with_nil
  HASH.fetch(:writing, true)
end

def fast_with_const
  HASH.fetch(:writing, HASH)
end

HASH.fetch(:writing)
