# coding: utf-8
lib = File.expand_path( '../lib', __FILE__ )
$LOAD_PATH.unshift( lib ) unless $LOAD_PATH.include?( lib )
require 'dansguardian_denied_action/version'

Gem::Specification.new do |spec|
  spec.name          = 'dansguardian_denied_action'
  spec.version       = DansguardianDeniedAction::VERSION
  spec.authors       = ['Eric Terry']
  spec.email         = ['eterry1388@aol.com']

  spec.summary       = 'Dansguardian Denied Action'
  spec.description   = "Triggers a custom action when a site is blocked/denied.  Works by monitoring the access log of Dansguardian or e2guardian."
  spec.homepage      = 'http://eterry1388.github.io/dansguardian_denied_action'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split( "\x0" ).reject { |f| f.match( %r{^(test|spec|features)/} ) }
  spec.executables   = spec.files.grep( %r{^bin/} ) { |f| File.basename( f ) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency 'filewatch', '~> 0.7'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'coveralls'
end
