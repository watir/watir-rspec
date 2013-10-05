# -*- encoding: utf-8 -*-
require File.expand_path('../lib/watir/rspec/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jarmo Pertman"]
  gem.email         = ["jarmo.p@gmail.com"]
  gem.description   = %q{Use Watir with RSpec with ease.}
  gem.summary       = %q{Use Watir with RSpec with ease.}
  gem.homepage      = "http://github.com/watir/watir-rspec"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "watir-rspec"
  gem.require_paths = ["lib"]
  gem.version       = Watir::RSpec::VERSION

  gem.add_dependency "rspec", "~>2.0"
  gem.add_dependency "watir", "~>5.0"

  gem.add_development_dependency "yard"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "redcarpet"
end
