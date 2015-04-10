# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nanoc/polly/version'

Gem::Specification.new do |spec|
  spec.name          = "nanoc-polly"
  spec.version       = Nanoc::Polly::VERSION
  spec.authors       = ["Alex Berger"]
  spec.email         = ["alex@more-onion.com"]
  spec.summary       = %q{Integrates Pollypost with nanoc.}
  spec.homepage      = "http://www.pollypost.org"
  spec.license       = "GPL-3.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nanoc", "~> 3.7.5"
  spec.add_dependency "adsf", "~> 1.2.0"
  spec.add_dependency "sinatra", "~> 1.4.5"
  spec.add_dependency "loofah", "~> 2.0.1"
  spec.add_dependency "htmlbeautifier", "~> 1.1.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
