ARRAY = [*1..100]

ARRAY.select { |x| x.eql?(15) }.first

ARRAY.select do |x|
  x.eql?(15)
end.first

ARRAY.select(&:zero?).first

ActiveRecordRelation.new.select('name').first

ARRAY.select { |x| x.eql?(15) }.first(5)