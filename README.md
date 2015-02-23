[![Build Status](https://travis-ci.org/DamirSvrtan/fasterer.svg?branch=master)](https://travis-ci.org/DamirSvrtan/fasterer)

# Fasterer

Make your Rubies go faster with this command line tool inspired by [fast-ruby](https://speakerdeck.com/sferik/writing-fast-ruby) and [Sferik's talk at Baruco Conf](https://speakerdeck.com/sferik/writing-fast-ruby).

Fasterer will suggest some speed improvements which you can check in detail at the [fast-ruby repo](https://github.com/JuanitoFatas/fast-ruby).

**Please note** that you shouldn't follow the suggestions blindly. Using a while loop instead of a each_with_index shouldn't be considered if you're doing a regular Rails project, but maybe if you're doing something very speed dependent such as Rake you might consider this speed increase.



## Installation

```shell
gem install fasterer
```

## Usage

Run it from the root of your project:

```shell
fasterer
```

1. Parallel Assignment: :massign key
2. begin rescue vs respond_to? # Maybe no method error check
3. module_eval
4. find vs bsearch
5. Array#count vs Array#size
6. Array#shuffle.first vs Array#sample
7. Enumerable#each + push vs Enumerable#map
8. Enumerable#each vs for loop
9. Enumerable#each_with_index vs while
10. Enumerable#map...Array#flatten vs Enumerable#flat_map
11. Enumerable#reverse.each vs Enumerable#reverse_each
12. Enumerable#detect vs Enumerable#select.first
13. Enumerable#sort vs Enumerable#sort_by
14. Hash#fetch with argument vs Hash#fetch + block
15. Hash#each_key instead of Hash#keys.each
16. Hash#merge! vs Hash#[]=
17. Hash#merge vs Hash#merge!
18. Block vs Symbol#to_proc
19. Proc#call vs yield
20. String#casecmp vs String#downcase + ==
21. String concatenation
22. String#match vs String#start_with?/String#end_with?
23. String#gsub vs String#sub
24. String#gsub vs String#tr


Done:

1. Parallel Assignment: :massign key
2. begin rescue vs respond_to? # Maybe no method error check
3. module_eval
6. Array#shuffle.first vs Array#sample
8. Enumerable#each vs for loop
9. Enumerable#each_with_index vs while
10. Enumerable#map...Array#flatten vs Enumerable#flat_map
11. Enumerable#reverse.each vs Enumerable#reverse_each
12. Enumerable#detect vs Enumerable#select.first
13. Enumerable#sort vs Enumerable#sort_by http://brandon.dimcheff.com/2009/11/18/rubys-sort-vs-sort-by.html
15. Hash#each_key instead of Hash#keys.each
19. Proc#call vs yield
24. String#gsub vs String#tr

Other:

Method calls:

4. find vs bsearch
5. Array#count vs Array#size
17. Hash#merge vs Hash#merge!
18. Block vs Symbol#to_proc
20. String#casecmp vs String#downcase + ==
21. String concatenation
23. String#gsub vs String#sub

Method calls with argument recognition

14. Hash#fetch with argument vs Hash#fetch + block
16. Hash#merge! vs Hash#[]=
22. String#match vs String#start_with?/String#end_with?

Nested method calls

7. Enumerable#each + push vs Enumerable#map

## Conclusion

Use this tool while keeping your brain ON.


## Issues

# New

values each -> each_value
class_eval

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fasterer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
