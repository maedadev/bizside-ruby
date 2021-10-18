require_relative 'logger'

module Bizside
  module Audit
    class JobLogger < self::Logger

      # override
      # @see Bizside::Audit::Logger#file_path
      def file_path
        File.join('log', 'job_audit.log')
      end
    end
  end
end
