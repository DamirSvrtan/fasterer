require 'ostruct'

module TinyEnum
  def enum(name)
    @enums[name]
  end

  def define(name, opts = {})
    enums[name] = OpenStruct.new(opts.merge(name: name))
  end

  def enums
    @enums ||= {}
  end
end

module Fasterer
  class RescueVsRespondTo
    def slow
      begin
        writing
      rescue
        'fast ruby'
      end
    end

    def fast
      if respond_to?(:writing)
        writing
      else
        'fast ruby'
      end
    end
  end
end

module Fasterer
  class SelectFirstVsDetect
    ARRAY = [*1..100]

    def slow
      ARRAY.select { |x| x.eql?(15) }.first
    end

    def fast
      ARRAY.detect { |x| x.eql?(15) }
    end
  end
end

module Fasterer
  class ShuffleFirstVsSample
    def initialize
      @array = [*1..100]
    end

    def slow
      @array.shuffle.first
    end

    def fast
      @array.sample
    end

    def speed_factor
      7
    end
  end
end

module Fasterer
  class ProcCallVsYield
    def slow(&block)
      block.call
    end

    def fast
      yield
    end
  end
end

module Fasterer
  class ReverseEachVsReverseEach
    def initialize
      @array = [*1..1_000_000]
    end

    def slow
      @array.reverse.each { |el| el }
    end

    def fast
      @array.reverse_each { |el| el }
    end

    def speed_factor
      20
    end
  end
end

# define :rescue_vs_respond_to, {
#   message: 'Don\'t rescue NoMethodError, rather check with respond_to?',
#   bench_setup: Proc.new { array = [*1..100] },
#   bench_slow: -> { ARRAY.shuffle.first },
#   bench_fast: -> { binding.pry; ARRAY.sample },
#   speed_factor: 7
# }

class OffenseList
  extend TinyEnum

  define :rescue_vs_respond_to, {
    message: 'Don\'t rescue NoMethodError, rather check with respond_to?',
    bench_class: Fasterer::RescueVsRespondTo,
    speed_factor: 6
  }

  define :module_eval, {
    message: 'Using module_eval is slower than define_method',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :shuffle_first_vs_sample, {
    message: 'Array#shuffle.first is slower than Array#sample',
    bench_class: Fasterer::ShuffleFirstVsSample,
    speed_factor: 5
  }

  define :for_loop_vs_each, {
    message: 'For loop is slower than using each',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :each_with_index_vs_while, {
    message: 'Using each_with_index is slower than while loop',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :map_flatten_vs_flat_map, {
    message: 'Array#map.flatten(1) is slower than Array#flat_map',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :reverse_each_vs_reverse_each, {
    message: 'Array#reverse.each is slower than Array#reverse_each',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :select_first_vs_detect, {
    message: 'Array#select.first is slower than Array#detect',
    bench_class: Fasterer::SelectFirstVsDetect,
    speed_factor: 4
  }

  define :sort_vs_sort_by, {
    message: 'Enumerable#sort is slower than Enumerable#sort_by',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :fetch_with_argument_vs_block, {
    message: 'Hash#fetch with second argument is slower than Hash#fetch with block',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :keys_each_vs_each_key, {
    message: 'Hash#keys.each is slower than Hash#each_key. N.B. Hash#each_key cannot be used if the hash is modified during the each block',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :hash_merge_bang_vs_hash_brackets, {
    message: 'Hash#merge! with one argument is slower than Hash#[]',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :block_vs_symbol_to_proc, {
    message: 'Calling argumentless methods within blocks is slower than using symbol to proc',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :proc_call_vs_yield, {
    message: 'Calling blocks with call is slower than yielding',
    bench_class: Fasterer::ProcCallVsYield,
    speed_factor: 2.5
  }

  define :gsub_vs_tr, {
    message: 'Using tr is faster than gsub when replacing a single character in a string with another single character',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :select_last_vs_reverse_detect, {
    message: 'Array#select.last is slower than Array#reverse.detect',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :getter_vs_attr_reader, {
    message: 'Use attr_reader for reading ivars',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :setter_vs_attr_writer, {
    message: 'Use attr_writer for writing to ivars',
    bench_class: Fasterer,
    speed_factor: 5
  }

  define :include_vs_cover_on_range, {
    message: 'Use #cover? instead of #include? on ranges',
    bench_class: Fasterer,
    speed_factor: 5
  }
end
