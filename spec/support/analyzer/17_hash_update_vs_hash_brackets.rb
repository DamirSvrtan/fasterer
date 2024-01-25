h.update(item: 1, item2: 3)

h.update

h.update(item, item: 1)

h.update(item: 1)

ENUM.each_with_object({}) do |e, h|
  h.update(e => e)
end

ENUM.each_with_object({}) do |e, h|
  h[e] = e
end

h.update(item: 1)

h.update({item: 1})

h.update({})
