# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'watch_next/version'

Gem::Specification.new do |spec|
  spec.name          = "watch_next"
  spec.version       = WatchNext::VERSION
  spec.authors       = ["Vladimir Yarotsky"]
  spec.email         = ["vladimir.yarotsky@fmail.com"]
  spec.summary       = %q{Tells you which show to watch next}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock", "~> 1.20"
  spec.add_development_dependency "vcr", "~> 2.9"
  spec.add_development_dependency "minitest", "~> 5.4"
end
