[![Build Status](https://travis-ci.org/DamirSvrtan/fasterer.svg?branch=master)](https://travis-ci.org/DamirSvrtan/fasterer)
[![Code Climate](https://codeclimate.com/github/DamirSvrtan/fasterer/badges/gpa.svg)](https://codeclimate.com/github/DamirSvrtan/fasterer)
[![Gem Version](https://badge.fury.io/rb/fasterer.svg)](http://badge.fury.io/rb/fasterer)
# Fasterer

Make your Rubies go faster with this command line tool highly inspired by [fast-ruby](https://github.com/JuanitoFatas/fast-ruby) and [Sferik's talk at Baruco Conf](https://speakerdeck.com/sferik/writing-fast-ruby).

Fasterer will suggest some speed improvements which you can check in detail at the [fast-ruby repo](https://github.com/JuanitoFatas/fast-ruby).

**Please note** that you shouldn't follow the suggestions blindly. Using a while loop instead of a each_with_index probably shouldn't be considered if you're doing a regular Rails project, but maybe if you're doing something very speed dependent such as Rack or if you're building your own framework, you might consider this speed increase.



## Installation

```shell
gem install fasterer
```

## Usage

Run it from the root of your project:

```shell
fasterer
```

## Example output

```shell

app/models/post.rb
Array#select.first is slower than Array#detect. Occured at lines: 57, 61.

db/seeds/cities.rb
Hash#keys.each is slower than Hash#each_key. Occured at lines: 15, 33.

test/options_test.rb
Hash#merge! with one argument is slower than Hash#[]. Occured at lines: 84.

test/module_test.rb
Don't rescue NoMethodError, rather check with respond_to?. Occured at lines: 272.

spec/cache/mem_cache_store_spec.rb
Use tr instead of gsub when grepping plain strings. Occured at lines: 161.
```
## Configuration

Configuration is done through the **.fasterer.yml** file placed in the root of your project.

Options:

  * Turn off speed suggestions
  * Blacklist files or complete folder paths

Example:


```yaml
speedups:
  parallel_assignment: false
  rescue_vs_respond_to: true
  module_eval: true
  shuffle_first_vs_sample: true
  for_loop_vs_each: true
  each_with_index_vs_while: false
  map_flatten_vs_flat_map: true
  reverse_each_vs_reverse_each: true
  select_first_vs_detect: true
  sort_vs_sort_by: true
  fetch_with_argument_vs_block: true
  keys_each_vs_each_key: true
  hash_merge_bang_vs_hash_brackets: true
  block_vs_symbol_to_proc: true
  proc_call_vs_yield: true
  gsub_vs_tr: true
  select_last_vs_reverse_detect: true
  getter_vs_attr_reader: true
  setter_vs_attr_writer: true

exclude_paths:
  - 'vendor/**/*.rb'
  - 'db/schema.rb'
```

## Speedups TODO:

4. find vs bsearch
5. Array#count vs Array#size
7. Enumerable#each + push vs Enumerable#map
17. Hash#merge vs Hash#merge!
20. String#casecmp vs String#downcase + ==
21. String concatenation
22. String#match vs String#start_with?/String#end_with?
23. String#gsub vs String#sub

## Contributing

1. Fork it ( https://github.com/DamirSvrtan/fasterer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
