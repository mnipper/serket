# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'serket/version'

Gem::Specification.new do |spec|
  spec.name          = "serket"
  spec.version       = Serket::VERSION
  spec.authors       = ["Michael Nipper"]
  spec.email         = ["mjn4406@gmail.com"]
  spec.description   = %q{Automatically encrypt and decrypt fields.}
  spec.summary       = %q{Automatically encrypt and decrypt fields using RSA and AES-256-CBC.}
  spec.homepage      = "https://github.com/mnipper/serket"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
