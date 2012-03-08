# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-lastfm/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-lastfm"
  s.version     = Omniauth::Lastfm::VERSION
  s.authors     = ["Claudio Poli"]
  s.email       = ["claudio@audiobox.fm"]
  s.homepage    = "http://github.com/masterkain/omniauth-lastfm"
  s.summary     = %q{OmniAuth strategy for Last.fm}
  s.description = %q{OmniAuth strategy for Last.fm}

  s.rubyforge_project = "omniauth-lastfm"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.7"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "webmock"
  s.add_runtime_dependency "omniauth-oauth", "~> 1.0"
end
