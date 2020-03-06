module Fasterer
  class Offense
    attr_reader :offense_name, :line_number

    alias_method :name, :offense_name
    alias_method :line, :line_number

    def initialize(offense_name, line_number)
      @offense_name = offense_name
      @line_number  = line_number
      explanation # Set explanation right away.
    end

    def explanation
      @explanation ||= begin
        info, link = EXPLANATIONS.fetch(offense_name).values
        "#{info}. See more: #{link}"
      end
    end

    EXPLANATIONS = {
      rescue_vs_respond_to: {
        info: 'Don\'t rescue NoMethodError, rather check with respond_to?',
        link: 'https://github.com/JuanitoFatas/fast-ruby#beginrescue-vs-respond_to-for-control-flow-code'
      },

      module_eval: {
        info: 'Using module_eval is slower than define_method',
        link: 'https://github.com/JuanitoFatas/fast-ruby#define_method-vs-module_eval-for-defining-methods-code'
      },

      shuffle_first_vs_sample: {
        info: 'Array#shuffle.first is slower than Array#sample',
        link: 'https://github.com/JuanitoFatas/fast-ruby#arrayshufflefirst-vs-arraysample-code'
      },

      for_loop_vs_each: {
        info: 'For loop is slower than using each',
        link: 'https://github.com/JuanitoFatas/fast-ruby#enumerableeach-vs-for-loop-code'
      },

      each_with_index_vs_while: {
        info: 'Using each_with_index is slower than while loop',
        link: 'https://github.com/JuanitoFatas/fast-ruby#enumerableeach_with_index-vs-while-loop-code'
      },

      map_flatten_vs_flat_map: {
        info: 'Array#map.flatten(1) is slower than Array#flat_map',
        link: 'https://github.com/JuanitoFatas/fast-ruby#enumerablemaparrayflatten-vs-enumerableflat_map-code'
      },

      reverse_each_vs_reverse_each: {
        info: 'Array#reverse.each is slower than Array#reverse_each',
        link: 'https://github.com/JuanitoFatas/fast-ruby#enumerablereverseeach-vs-enumerablereverse_each-code'
      },

      select_first_vs_detect: {
        info: 'Array#select.first is slower than Array#detect',
        link: 'https://github.com/JuanitoFatas/fast-ruby#enumerabledetect-vs-enumerableselectfirst-code'
      },

      sort_vs_sort_by: {
        info: 'Enumerable#sort is slower than Enumerable#sort_by',
        link: 'https://github.com/JuanitoFatas/fast-ruby#enumerablesort-vs-enumerablesort_by-code'
      },

      fetch_with_argument_vs_block: {
        info: 'Hash#fetch with second argument is slower than Hash#fetch with block',
        link: 'https://github.com/JuanitoFatas/fast-ruby#hashfetch-with-argument-vs-hashfetch--block-code'
      },
  
      keys_each_vs_each_key: {
        info: 'Hash#keys.each is slower than Hash#each_key. N.B. Hash#each_key cannot be used if the hash is modified during the each block',
        link: 'https://github.com/JuanitoFatas/fast-ruby#hasheach_key-instead-of-hashkeyseach-code'
      },

      hash_merge_bang_vs_hash_brackets: {
        info: 'Hash#merge! with one argument is slower than Hash#[]',
        link: 'https://github.com/JuanitoFatas/fast-ruby#hashmerge-vs-hash-code'
      },

      block_vs_symbol_to_proc: {
        info: 'Calling argumentless methods within blocks is slower than using symbol to proc',
        link: 'https://github.com/JuanitoFatas/fast-ruby#block-vs-symbolto_proc-code'
      },

      proc_call_vs_yield: {
        info: 'Calling blocks with call is slower than yielding',
        link: 'https://github.com/JuanitoFatas/fast-ruby#proccall-and-block-arguments-vs-yieldcode'
      },

      gsub_vs_tr: {
        info: 'Using tr is faster than gsub when replacing a single character in a string with another single character',
        link: 'https://github.com/JuanitoFatas/fast-ruby#stringgsub-vs-stringtr-code'
      },

      select_last_vs_reverse_detect: {
        info: 'Array#select.last is slower than Array#reverse.detect',
        link: 'https://github.com/JuanitoFatas/fast-ruby#enumerableselectlast-vs-enumerablereversedetect-code'
      },

      getter_vs_attr_reader: {
        info: 'Use attr_reader for reading ivars',
        link: 'https://github.com/JuanitoFatas/fast-ruby#attr_accessor-vs-getter-and-setter-code'
      },

      setter_vs_attr_writer: {
        info: 'Use attr_writer for writing to ivars',
        link: 'https://github.com/JuanitoFatas/fast-ruby#attr_accessor-vs-getter-and-setter-code'
      },

      include_vs_cover_on_range: {
        info: 'Use #cover? instead of #include? on ranges',
        link: 'https://github.com/JuanitoFatas/fast-ruby#cover-vs-include-code'
      }
    }
  end
end
