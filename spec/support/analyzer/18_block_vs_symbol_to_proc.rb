route_sets.each do |routes|

end

route_sets.each do |routes|
  routes.finalize!
end

route_sets.each do |route|
  route.finalize!
  puts route.name
end

route_sets.each(&:finalize!)

route_sets.each(:oppa) do |route|
  route.finalize!
end

route_sets.each do |routes|
  routes.finalize!(1)
end

route_sets.each do |routes|
  routes.finalize do
    puts 'opp'
  end
end

route_sets.each { |routes| routes.finalize! }

numbers = [1, 2, 3, 4, 5]
numbers.each { |number| number.to_s }
numbers.map { |number| number.to_s }
numbers.any? { |number| number.even? }
numbers.find { |number| number.even? }
