# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'made_chan/version'

Gem::Specification.new do |spec|
  spec.name          = "made_chan"
  spec.version       = MadeChan::VERSION
  spec.authors       = ["Tatumaki"]
  spec.email         = ["Tatumaki.x.euphoric@gmail.com"]
  spec.summary       = %q{My exclusive maid. She always helps me when I want, just only her.}
  spec.description   = %q{What? you HAVE GIRL FRIEND!? hey, nonono keep off, leave me alone and do not use my made_chan!!}
  spec.homepage      = ""
  spec.license       = "GNUGPLv3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
