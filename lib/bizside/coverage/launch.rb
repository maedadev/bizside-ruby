module Bizside
  module Coverage
    class Launch

      def self.load
        if ENV["COVERAGE"].to_s.downcase == 'true' and ENV['ACCEPTANCE_TEST'].to_s.downcase == 'true'
          setup()

          SimpleCov.start 'rails' do
            SimpleCov.command_name(ENV['COMMAND_NAME']) if ENV['COMMAND_NAME']
            SimpleCov.merge_timeout(7200)
          end
        end
      end

      def self.load_from_test_helper
        if ENV["COVERAGE"] == 'true'
          setup()
          SimpleCov.start 'rails'
        end
      end

      def self.setup
        require 'simplecov'
        require 'simplecov-rcov'
        require_relative 'rcov_formatter'
        SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
          SimpleCov::Formatter::HTMLFormatter,
          Bizside::Coverage::RcovFormatter
        ])
      end
      private_class_method :setup
    end
  end
end
