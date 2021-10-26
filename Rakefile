lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/gem_tasks'
require 'bizside/version'
require 'bizside/tasks'

desc 'bizside_test_app を利用してテストを実行します。'
task :test do
  require 'bundler'

  commands = [
    'bundle install',
    'rails log:clear',
    'rails test'
  ]

  Dir.chdir('bizside_test_app') do
    Bundler.with_clean_env do
      fail unless system commands.join(' && ')
    end
  end
end
