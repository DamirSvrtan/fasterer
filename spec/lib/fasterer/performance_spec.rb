require 'spec_helper'

describe 'performance spec' do
  it 'respond_to performs faster than rescue' do
    offense = OffenseList.enum(:rescue_vs_respond_to)
    bench = offense.bench_class.new
    expect { bench.fast }.to perform_faster_than { bench.slow }.at_least(offense.speed_factor).times
  end

  it 'detect performs faster than select first' do
    offense = OffenseList.enum(:select_first_vs_detect)
    bench = offense.bench_class.new
    expect { bench.fast }.to perform_faster_than { bench.slow }.at_least(offense.speed_factor).times
  end

  it 'yield performs faster than proc.call' do
    offense = OffenseList.enum(:proc_call_vs_yield)
    bench = offense.bench_class.new
    expect { bench.fast { 1 + 1 } }.to perform_faster_than { bench.slow { 1 + 1 } }.at_least(offense.speed_factor).times
  end
end
