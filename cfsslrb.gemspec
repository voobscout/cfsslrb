# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cfsslrb/version'

Gem::Specification.new do |spec|
  spec.name          = "cfsslrb"
  spec.version       = Cfsslrb::VERSION
  spec.authors       = ["voobscout"]
  spec.email         = ["voobscout@archlinux.info"]

  spec.summary       = %q{cfsslrb - yml instead of json}
  spec.description   = spec.summary
  spec.homepage      = "http://"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  # spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-awesome_print'

  spec.add_dependency 'corefines'
  spec.add_dependency 'cocaine'
  spec.add_dependency 'clamp'
  spec.add_dependency 'activesupport'
end
