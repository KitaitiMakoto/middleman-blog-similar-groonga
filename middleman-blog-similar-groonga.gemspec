# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "middleman-blog-similar-groonga"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.license     = "LGPL"
  s.authors     = ["KITAITI Makoto"]
  s.email       = ["KitaitiMakoto@gmail.com"]
  s.homepage    = "https://github.com/KitaitiMakoto/middleman-blog-similar-groonga"
  s.summary     = %q{Middleman extension to list similar pages using Groonga}
  s.description = %q{Middleman extension to list similar pages using Groonga}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 4.0.0"])
  
  # Additional dependencies
  # s.add_runtime_dependency("gem-name", "gem-version")
  s.add_runtime_dependency("rroonga")
  s.add_runtime_dependency("middleman-blog", [">= 4.0.0"])
end
