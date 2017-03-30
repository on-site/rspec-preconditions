# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/preconditions/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-preconditions"
  spec.version       = Rspec::Preconditions::VERSION
  spec.authors       = ["Isaac Betesh"]
  spec.email         = ["ibetesh@on-site.com"]

  spec.summary       = 'Skip duplicate RSpec failures.'
  spec.description   = %(
      Sometimes every example in an RSpec example group fails because of a bug
      in the before hook.
      Wouldn't you rather see the error only once, rather than for every single
      example?
      Now you can.
    )
  spec.homepage      = 'https://github.com/on-site/rspec-preconditions'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'rspec-core'
  spec.add_dependency 'rspec-expectations'
end
