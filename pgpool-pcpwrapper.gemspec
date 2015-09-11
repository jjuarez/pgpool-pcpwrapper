# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pgpool/version'

Gem::Specification.new do |spec|
  spec.name          = 'pgpool-pcpwrapper'
  spec.version       = PGPool::VERSION
  spec.authors       = ['Javier Juarez']
  spec.email         = ['jjuarez@tuenti.com']

  spec.summary       = 'A PGPool PCP interface wrapper.'
  spec.description   = 'A PGPool PCP interface wrapper.'
  spec.homepage      = 'https://github.com/jjuarez/pgpool-pcpwrapper'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version     = '>= 1.9'
  spec.required_rubygems_version = '>= 1.8'

  spec.add_dependency 'mixlib-shellout', '~> 2.1'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.34'
end
