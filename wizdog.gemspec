# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wizdog/version"

Gem::Specification.new do |s|
  s.name        = "wizdog"
  s.version     = Wizdog::VERSION
  s.authors     = ["songgz"]
  s.email       = ["sgzhe@163.com"]
  s.homepage    = "http://github.com/songgz/wizdog"
  s.summary     = "Flexible authentication solution for Rails"
  s.description = "Flexible authentication solution for Rails"

  s.rubyforge_project = "wizdog"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
