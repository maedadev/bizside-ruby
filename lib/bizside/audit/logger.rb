require 'singleton'
require 'logger'
require 'ltsv'

module Bizside
  module Audit
    class Logger
      include Singleton

      def self.logger
        self.instance
      end

      def initialize
        path = file_path
        FileUtils.mkdir_p( File.dirname(path) )
        file = File.open(path, 'a')
        file.sync = true

        @logger = ::Logger.new(file)
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "#{msg}\n"
        end
      end

      def record(info = {})
        @logger.info LTSV.dump(info)
      end

      def file_path
        File.join('log', 'audit.log')
      end
    end
  end
end
