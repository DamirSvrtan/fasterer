# Should detect only the block.call, not the others.
def call_me(number, zumba, &block)
  4.call
  [1,2].call
  block.call
  b.call
  abakus(:red).calling()
end

# Should detect only the first block call.
def call_meeee(number, zumba, &block)
  block.call()
  block.call
end

# Shouldn't detect the block call since it isn't in the arguments.
def call_meeee(number, zumba)
  block.call
end

# Should detect the block call with arguments.
def call_meeee(number, zumba, &block)
  block.call(number)
end
