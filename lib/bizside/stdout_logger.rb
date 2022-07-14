module Bizside
  class StdoutLogger

      def initialize(app)
        @app = app
        console = ActiveSupport::Logger.new(STDOUT)
        console.formatter = Rails.logger.formatter
        console.level = Rails.logger.level

        unless ActiveSupport::Logger.logger_outputs_to?(Rails.logger, STDOUT)
          Rails.logger.extend(ActiveSupport::Logger.broadcast(console))
        end
      end

      def call(env)
        return @app.call(env)
      end

  end
end
