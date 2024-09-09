module Bizside
  module Acl
    module ControllerHelper
      include Bizside::Acl::AvailableHelper

      def authorize_user!
        return if available_for(params[:controller], params[:action], params)

        if request.xhr?
          head :forbidden
        else
          redirect_to root_path
        end
      end

    end
  end
end
