$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "blacklight/citeproc/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "blacklight-citeproc"
  spec.version     = Blacklight::Citeproc::VERSION
  spec.authors     = ["Jane Sandberg"]
  spec.email       = ["sandbej@linnbenton.edu"]
  spec.homepage    = "https://github.com/sandbergja/blacklight-citeproc"
  spec.summary     = ""
  spec.description = ""
  spec.license     = "Apache-2.0"
  
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency "bibtex-ruby", ">= 4.4.6"
  spec.add_dependency "citeproc-ruby", "~> 1.1"
  spec.add_dependency "csl-styles", "~> 1.0.1.9"

  spec.add_development_dependency "rspec-rails", "~> 3.0"
  spec.add_development_dependency "engine_cart", "~> 2.0"
  spec.add_development_dependency "solr_wrapper"

end

