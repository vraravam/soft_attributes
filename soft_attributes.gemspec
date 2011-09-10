# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "soft_attributes/version"


Gem::Specification.new do |s|
  s.name = 'soft_attributes'
  s.summary = 'A library for ensuring that calculated attributes are initialized lazily and serialized/de-serialized correctly.'
  s.version = SoftAttributes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.description = <<-EOS
    SoftAttributes provides a consistent way to define "soft" attributes on ActiveSupport.
    Typically calculated (non-persisted) attributes would be termed soft attributes.
    These will be included in the xml/json payload for serialization, but will need to be discarded
    if they appear in the incoming request.
  EOS

  s.authors = ['Vijay Aravamudhan']
  s.email = ['avijayr@gmail.com']
  s.homepage = 'http://github.com/vraravam/soft_attributes'
  s.rubyforge_project = "soft_attributes"
  s.has_rdoc = true

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'activesupport', '>= 2.1.0', '< 3.1.0'
  s.add_runtime_dependency 'activerecord', '>= 2.1.0', '< 3.1.0'
  s.add_runtime_dependency 'activeresource', '>= 2.1.0', '< 3.1.0'

  s.add_development_dependency 'sqlite3-ruby', '~> 1.3.3'
  s.add_development_dependency 'rspec', '~>2.6.0'
  # s.add_development_dependency 'rspec-rails', '~>2.6.0'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'webrat'
  s.add_development_dependency 'nokogiri'
end
