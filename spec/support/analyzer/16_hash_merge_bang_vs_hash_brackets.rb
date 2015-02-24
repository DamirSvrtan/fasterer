h.merge!(item: 1, item2: 3)

h.merge!

h.merge!(item, item: 1)

h.merge(item: 1)

ENUM.each_with_object({}) do |e, h|
  h.merge!(e => e)
end

ENUM.each_with_object({}) do |e, h|
  h[e] = e
end

h.merge!(item: 1)

h.merge!({item: 1})

h.merge!({})
