require_relative 'lib/belvo/version'

Gem::Specification.new do |spec|
  spec.name          = "belvo"
  spec.version       = Belvo::VERSION
  spec.authors       = ["Belvo Finance S.L."]
  spec.email         = ["hello@belvo.co"]

  spec.summary       = %q{The Ruby gem for the Belvo API}
  spec.description   = %q{Belvo is the leading Open Banking API platform in Latin America and the easiest way for users to connect their account to an app}
  spec.homepage      = "https://github.com/belvo-finance/belvo-ruby"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/belvo-finance/belvo-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/belvo-finance/belvo-ruby/blob/master/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
