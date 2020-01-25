ARRAY = (1..100).to_a

def slow
  ARRAY.count # return 100
end

def fast
  ARRAY.size # return 100
end

def justified_to_use_count
  ARRAY.count(5) # return 1
  ARRAY.count { |x| x.even? } # return 50
end

def not_array
  # always execute SQL count
  ActiveRecord::Relation.new.count
  scope = ActiveRecord::Relation.new
  scope.count
end