module Bizside
  class CoverageLaunch
    def self.setup
      require 'simplecov'
      require 'simplecov-rcov'
      require_relative 'rcov_formatter'
      SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::HTMLFormatter,
        Coverage::RcovFormatter
      ])
    end
  end
end

if Bizside::Yes.confirmed?(ENV['COVERAGE']) and Bizside::Yes.confirmed?(ENV['ACCEPTANCE_TEST'])
  Bizside::CoverageLaunch.setup()

  SimpleCov.start 'rails' do
    SimpleCov.command_name(ENV['COMMAND_NAME']) if ENV['COMMAND_NAME']
    SimpleCov.merge_timeout(7200)
  end
elsif Bizside::Yes.confirmed?(ENV['COVERAGE'])
  Bizside::CoverageLaunch.setup()
  SimpleCov.start 'rails'
end
