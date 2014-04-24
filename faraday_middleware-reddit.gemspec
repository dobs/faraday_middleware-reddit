# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday_middleware/reddit/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'faraday'

  spec.name          = "faraday_middleware-reddit"
  spec.version       = FaradayMiddleware::Reddit::VERSION
  spec.authors       = ["Daniel O'Brien"]
  spec.email         = ["dan@dobs.org"]
  spec.description   = %q{A collection of Faraday middleware for use with the Reddit API.}
  spec.summary       = %q{A collection of Faraday middleware for use with the Reddit API.}
  spec.homepage      = ""
  spec.licenses       = ['Apache 2.0']

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware', '~> 0.9'
end
