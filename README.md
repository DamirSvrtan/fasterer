[![Build Status](https://travis-ci.org/DamirSvrtan/fasterer.svg?branch=master)](https://travis-ci.org/DamirSvrtan/fasterer)
# Fasterer

Make your Rubies go faster with this command line tool highly inspired by [fast-ruby](https://github.com/JuanitoFatas/fast-ruby) and [Sferik's talk at Baruco Conf](https://speakerdeck.com/sferik/writing-fast-ruby).

Fasterer will suggest some speed improvements which you can check in detail at the [fast-ruby repo](https://github.com/JuanitoFatas/fast-ruby).

**Please note** that you shouldn't follow the suggestions blindly. Using a while loop instead of a each_with_index shouldn't be considered if you're doing a regular Rails project, but maybe if you're doing something very speed dependent such as Rack you might consider this speed increase.



## Installation

```shell
gem install fasterer
```

## Usage

Run it from the root of your project:

```shell
fasterer
```

## TODOs:

4. find vs bsearch
5. Array#count vs Array#size
7. Enumerable#each + push vs Enumerable#map
14. Hash#fetch with argument vs Hash#fetch + block
16. Hash#merge! vs Hash#[]=
17. Hash#merge vs Hash#merge!
18. Block vs Symbol#to_proc
20. String#casecmp vs String#downcase + ==
21. String concatenation
22. String#match vs String#start_with?/String#end_with?
23. String#gsub vs String#sub

# New

values each -> each_value
class_eval

## Contributing

1. Fork it ( https://github.com/DamirSvrtan/fasterer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
