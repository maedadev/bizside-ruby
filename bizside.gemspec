lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bizside/version'

Gem::Specification.new do |s|
  s.name        = 'bizside'
  s.version     = Bizside::VERSION
  s.summary     = 'Bizside is an utilities for web application.'
  s.description = 'Bizside is an utilities to assist building web application.'
  s.authors     = ['bizside-developers']
  s.email       = ['bizside-developers@lab.acs-jp.com']
  s.homepage    = 'https://github.com/maedadev/bizside-ruby'
  s.licenses    = 'MIT'
  s.files       = Dir['app/**/*'] +
                  Dir['lib/**/*'] +
                  Dir['rails/**/*'] +
                  Dir['validations/**/*']

  s.required_ruby_version = '>= 2.5.0'

  s.add_runtime_dependency 'activesupport', '>= 5.0.0', '< 6.0.0'
  s.add_runtime_dependency 'aws-sdk-s3', '~> 1.94'
  s.add_runtime_dependency 'capistrano', '< 3.0.0'
  s.add_runtime_dependency 'carrierwave', '~> 2.2'
  s.add_runtime_dependency 'carrierwave-magic', '~> 0.0.4'
  s.add_runtime_dependency 'fog-aws', '~> 3.0'
  s.add_runtime_dependency 'faraday', '>= 0.12', '< 2.0.0'
  s.add_runtime_dependency 'ltsv', '~> 0.1'
  s.add_runtime_dependency 'mimemagic', '~> 0.3.10'
  s.add_runtime_dependency 'mime-types', '~> 3.1'
  s.add_runtime_dependency 'rake', '>= 12.3', '< 14.0'

  s.add_development_dependency 'RedCloth', '~> 4.2'
  s.add_development_dependency 'capybara', '~> 3.0', '< 3.36'
  s.add_development_dependency 'cucumber', '~> 7.1'
  s.add_development_dependency 'cucumber-rails', '~> 2.5'
  s.add_development_dependency 'devise', '>= 3.4.0', '< 5.0.0'
  s.add_development_dependency 'ipaddress', '~> 0.8'
  s.add_development_dependency 'rails', '>= 5.0.0', '< 6.0.0'
  s.add_development_dependency 'resque', '>= 1.27', '< 3.0.0'
  s.add_development_dependency 'rmagick', '>= 4.2.3', '< 5.0.0'
  s.add_development_dependency 'sqlite3', '>= 1.3', '< 1.5.0'
end
