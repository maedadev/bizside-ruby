module Bizside
  module Acl
    module ControllerHelper
      include Bizside::Acl::AvailableHelper

      def authorize_user!
        unless available_for(params[:controller], params[:action], params)
          redirect_to root_path
          return
        end
      end

    end
  end
end
