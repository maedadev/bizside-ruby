module Bizside
  class UserAgent
    module ControllerHelper
      extend ActiveSupport::Concern

      included do
        case Rails::VERSION::MAJOR
        when 5, 6
          before_action :detect_user_agent
        else
          raise "Rails-#{Rails::VERSION::MAJOR} は未対応です。"
        end

        ::ActionController::Base.helper_method :user_agent
      end

      protected

      def detect_user_agent
        if params[:ua].present?
          self.user_agent = ::Bizside::UserAgent.new(params[:ua], request.env['HTTP_USER_AGENT'])
        else
          self.user_agent = ::Bizside::UserAgent.parse(request.env['HTTP_USER_AGENT'])
        end

        set_request_variant

        request.env['BIZSIDE_DEVICE'] = self.user_agent.name
      end

      def set_request_variant
        if self.user_agent.present? && self.user_agent.priorities.present?
          request.variant = self.user_agent.priorities.map(&:to_sym)
        end
      end

      def user_agent
        @_user_agent
      end

      def user_agent=(value)
        @_user_agent = value
      end

    end
  end
end
