route_sets.each do |routes|
  routes.finalize!
end

route_sets.each(&:finalize!)

route_sets.each(:oppa) do |route|
  route.finalize!
end

route_sets.each do |routes|
  routes.finalize!(1)
end

route_sets.each { |routes| routes.finalize! }
