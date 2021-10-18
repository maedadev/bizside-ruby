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

if ENV["COVERAGE"].to_s.downcase == 'true' and ENV['ACCEPTANCE_TEST'].to_s.downcase == 'true'
  Bizside::CoverageLaunch.setup()

  SimpleCov.start 'rails' do
    SimpleCov.command_name(ENV['COMMAND_NAME']) if ENV['COMMAND_NAME']
    SimpleCov.merge_timeout(7200)
  end
elsif ENV["COVERAGE"]
  Bizside::CoverageLaunch.setup()
  SimpleCov.start 'rails'
end
