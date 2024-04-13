# frozen_string_literal: true

require_relative "lib/tailwindcss/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-tailwindcss"
  spec.version = Tailwindcss::VERSION
  spec.authors = ["Mike Vormwald"]
  spec.email = ["mvormwald@gmail.com"]

  spec.summary = "Integrate Tailwind CSS into your Jekyll site."
  spec.homepage = "https://github.com/vormwald/jekyll-tailwindcss"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  #spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["spec.homepage"] = spec.homepage
  spec.metadata["spec.changelog"] = "#{spec.homepage}/blob/main/CODE_OF_CONDUCT.md"

  spec.required_rubygems_version = ">= 3.2.0" # for Gem::Platform#match_gem?

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
