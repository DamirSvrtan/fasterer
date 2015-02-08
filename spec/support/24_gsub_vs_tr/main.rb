'abcd abcd'.gsub(' ', '')

petar = 'petar'

petar.gsub('r', 'k')
petar.gsub(/abba/, 'k')

petar.gsub(/*a\ab\//, 'k')

class Hello
  def hihi
    'alfabet'.gsub('r', 'b'.gsub('a', 'z'))
  end
end
