class A
  def count; end
end
b = A.new
b.count
{}.count
[].size
[].length
[].count
[].count(1)
[].count { |a| false }
[].count do |a|
  false
end