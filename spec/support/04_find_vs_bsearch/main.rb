data = [1,2,3]

data.bsearch { |number| number > 77_777_777 }
data.find    { |number| number > 77_777_777 }

