Gem::Specification.new do |spec|
  spec.name          = "lita-docker"
  spec.version       = "0.1.0"
  spec.authors       = ["Will Weaver"]
  spec.email         = ["monkey@buildingbananas.com"]
  spec.description   = %q{Lita handler for Docker.}
  spec.summary       = %q{Lita handler for Docker.}
  spec.homepage      = "https://github.com/funkymonkeymonk/lita-docker"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.6.0"
  spec.add_runtime_dependency "docker-api"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "guard-rspec"
end
