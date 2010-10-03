require 'rake'

Gem::Specification.new do |s|
  s.name = 'soft_attributes'
  s.summary = 'A library for ensuring that calculated attributes are initialized lazily and serialized/de-serialized correctly.'
  s.version = '0.0.1'
  s.description = <<-EOS
    SoftAttributes provides a consistent way to define "soft" attributes on ActiveSupport.
    Typically calculated (non-persisted) attributes would be termed soft attributes.
    These will be included in the xml/json payload for serialization, but will need to be discarded
    if they appear in the incoming request.
  EOS

  s.author = 'Vijay Aravamudhan'
  s.email = 'avijayr@gmail.com'
  s.homepage = 'http://github.com/vraravam/soft_attributes'
  s.has_rdoc = true

  s.files = FileList['lib/**/*.rb', '[A-Z]*', 'spec/**/*'].to_a
  s.test_files = FileList['spec/soft_attributes/**/*.rb']

  s.add_dependency 'actionpack', '>= 2.1.0'
  s.add_dependency 'activerecord', '>= 2.1.0'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
end