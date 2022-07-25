require_relative 'audit/logger'

module Bizside
  class AuditLog

    @@ignore_paths = []

    def self.ignore_paths=(paths)
      @@ignore_paths = paths
    end


    def initialize(app)
      @app = app
    end

    def call(env)
      start = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%3N%z')
      @status, @headers, @response = @app.call(env)
      stop = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%3N%z')      
      exception = env[Bizside::ShowExceptions::BIZSIDE_EXCEPTION_ENV_KEY]

      if env['BIZSIDE_SUPPRESS_AUDIT']
        return @status, @headers, @response
      end

      if @@ignore_paths.any? do |path|
          case path
          when Regexp
            env['REQUEST_URI'] =~ path
          else
            env['REQUEST_URI'] == path
          end
        end
        return @status, @headers, @response
      end

      if Bizside.rails_env&.development?
        return @status, @headers, @response if env['REQUEST_URI'] =~ /\/[^\/]+\/assets\/.*/
      elsif Bizside.rails_env&.test?
        return @status, @headers, @response
      end

      info = build_loginfo(env, start, stop, @status, exception)
      logger.record(info)

      return @status, @headers, @response
    end

    private

    def logger
      @logger ||= Bizside::Audit::Logger.logger
    end

    def build_loginfo(env, start, stop, status, exception)
      info = {
        time: start,
        add_on_name: detect_add_on_name(env),
        feature: detect_feature(env),
        action: detect_action(env),
        data: detect_data(env),
        interactive: detect_interactive(env),
        company: detect_company(env),
        user: detect_user(env),
        employee_code: detect_employee_code(env),
        department: detect_department(env),
        project: detect_project(env),
        server_name: env['SERVER_NAME'],
        server_address: ENV['HOSTNAME'] || env['SERVER_ADDR'], # nginx と apache で異なる
        server_port: env['SERVER_PORT'],
        scheme: env['rack.url_scheme'],
        path: env['PATH_INFO'],
        referrer: env['HTTP_REFERER'],
        request_method: env['REQUEST_METHOD'],
        request_uri: env['BIZSIDE_REQUEST_URI'].presence || env['REQUEST_URI'],
        remote_address: env['REMOTE_ADDR'],
        status: status,
        started_at: start,
        finished_at: stop,
        device: detect_device(env),
        user_agent: detect_user_agent(env),
        exception: detect_exception(exception),
        exception_message: detect_exception_message(exception),
        exception_backtrace: detect_exception_backtrace(exception)
      }

      info
    end

    def detect_company(env)
      env['BIZSIDE_COMPANY']
    end

    def detect_user(env)
      ret = env['BIZSIDE_USER']
      ret ||= Bizside::ShibUtils._get_bizside_user(env)
      
      if ret.to_s.empty?
        if defined?(Devise)
          warden = env['warden']
          if warden.authenticate?
            auth_user = warden.send(warden.config[:default_scope])
            ret = auth_user.email
          end
        end
      end

      ret
    end

    def detect_add_on_name(env)
      ret = env['BIZSIDE_ADD_ON_NAME']
      ret ||= Bizside.config.add_on_name
      ret
    end

    def detect_feature(env)
      env['BIZSIDE_FEATURE']
    end

    def detect_action(env)
      env['BIZSIDE_ACTION']
    end

    def detect_data(env)
      env['BIZSIDE_DATA']
    end

    def detect_interactive(env)
      env['BIZSIDE_INTERACTIVE']
    end

    def detect_department(env)
      env['BIZSIDE_DEPARTMENT']
    end

    def detect_project(env)
      env['BIZSIDE_PROJECT']
    end

    def detect_device(env)
      env['BIZSIDE_DEVICE']
    end

    def detect_user_agent(env)
      ret = env['BIZSIDE_USER_AGENT']
      ret ||= env['HTTP_USER_AGENT']
      ret
    end

    def detect_employee_code(env)
      ret = env['BIZSIDE_EMPLOYEE_CODE']
      ret
    end

    def detect_exception(exception)
      return '' unless exception

      exception.class.name
    end

    def detect_exception_message(exception)
      return '' unless exception

      exception.to_s
    end

    def detect_exception_backtrace(exception)
      return '' unless exception

      exception.backtrace.join("\n")
    end

  end
end
