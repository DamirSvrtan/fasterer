User  = Struct.new(:name)
ARRAY = Array.new(3) do
  User.new(sprintf("%010d"), rand(1_000_000_000))
end

ARRAY.sort { |a, b| a.name <=> b.name }
ARRAY.sort_by(&:name)

ARRAY.sort
