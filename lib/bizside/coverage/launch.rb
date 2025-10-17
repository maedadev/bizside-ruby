module Bizside
  module Coverage
    class Launch

      def self.load
        if ENV["COVERAGE"].to_s.downcase == 'true' and ENV['ACCEPTANCE_TEST'].to_s.downcase == 'true'
          require 'simplecov'

          SimpleCov.start 'rails' do
            SimpleCov.command_name(ENV['COMMAND_NAME']) if ENV['COMMAND_NAME']
            SimpleCov.merge_timeout(7200)
          end
        end
      end

      def self.load_from_test_helper
        if ENV["COVERAGE"] == 'true'
          require 'simplecov'
          SimpleCov.start 'rails'
        end
      end
    end
  end
end
