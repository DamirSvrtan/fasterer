# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fasterer/version'

Gem::Specification.new do |spec|
  spec.name          = 'fasterer'
  spec.version       = Fasterer::VERSION
  spec.authors       = ['Damir Svrtan']
  spec.email         = ['damir.svrtan@gmail.com']
  spec.summary       = 'Run Ruby more than fast. Fasterer'
  spec.description   = 'Use Fasterer to check various places in your code that could be faster.'
  spec.homepage      = 'https://github.com/DamirSvrtan/fasterer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_dependency 'ruby_parser', '>= 3.19.1'

  spec.add_development_dependency 'bundler', '>= 1.6'
  spec.add_development_dependency 'pry',     '~> 0.10'
  spec.add_development_dependency 'rake',    '>= 12.3.3'
  spec.add_development_dependency 'rspec',   '~> 3.2'
  spec.add_development_dependency 'simplecov', '~> 0.9'
end
