lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bizside/version'
require 'bizside/tasks'

desc 'bizside.gemをビルドします。'
task :build do
  [ "bundle install",
    "gem build bizside.gemspec",
  ].each do |command|
    puts command
    system command
  end
end

desc 'biszide.gemをインストールします。'
task :install => :build do
  [ "sudo gem install bizside-#{Bizside::VERSION}.gem --no-document",
  ].each do |command|
    puts command
    system command
  end
end

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
