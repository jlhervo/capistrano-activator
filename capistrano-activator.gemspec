# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/activator/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-activator"
  spec.version       = Capistrano::Activator::VERSION
  spec.authors       = ["Jean-Loïc Hervo"]
  spec.email         = ["neural.footwork@gmail.com"]
  spec.summary       = %q{Capistrano 3 plugin for Typesafe activator stack.}
  spec.description   = %q{Capistrano 3 plugin offers a way to master continuous delivery with Play! Framework. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_dependency 'capistrano', '>= 3.0'
  spec.add_dependency 'capistrano-rvm'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
