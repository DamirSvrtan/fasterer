HASH = {
  red: 5,
  black: 10,
  grey: 15
}

HASH.keys.each(&:to_sym)

HASH.keys.each { |key| puts key.to_sym }

HASH.keys.each do |key|
  puts key.to_sym
end

HASH.each_key(&:to_sym)

@redis.keys('queue:*').each do |queue_name|
  puts queue_name
end
