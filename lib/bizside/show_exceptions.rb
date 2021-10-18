module Bizside
  class ShowExceptions

    BIZSIDE_EXCEPTION_ENV_KEY = 'bizside.exception'

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
        env[BIZSIDE_EXCEPTION_ENV_KEY] = exception # 発生した例外を保持
        raise exception
    end

  end
end
