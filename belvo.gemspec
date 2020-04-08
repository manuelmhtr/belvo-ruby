# frozen_string_literal: true

require_relative 'lib/belvo/version'

Gem::Specification.new do |spec|
  spec.name = 'belvo'
  spec.version = Belvo::VERSION
  spec.authors = ['Belvo Finance S.L.']
  spec.email = ['hello@belvo.co']
  spec.license = 'MIT'
  spec.summary = 'The Ruby gem for the Belvo API'
  spec.description = %(Belvo is the leading Open Banking API platform in Latin
                       America and the easiest way for users to connect their
                       account to an app)
  spec.homepage = 'https://github.com/belvo-finance/belvo-ruby'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/belvo-finance/belvo-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/belvo-finance/belvo-ruby/blob/master/README.md'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'typhoeus'

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.81.0'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'webmock'
end
