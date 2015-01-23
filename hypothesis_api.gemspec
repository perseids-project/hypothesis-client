# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hypothesis_api/version'
Gem::Specification.new do |spec|
  spec.name = "hypothesis_api"
  spec.version = HypothesisApi::VERSION
  spec.authors = ["balmas"]
  spec.email = ["balmas@gmail.com"]
  spec.summary = %q{Transforms Hypothesis Annotations to OA for Perseids}
  spec.description = spec.summary
  spec.homepage = ""
  spec.license = "GPL-3"
  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
