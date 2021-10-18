require_relative 'access_control_utils'

module Bizside::Acl::AvailableHelper
  
  def available_for(controller_name, action_name = nil, params = {})
    controller_name = controller_name[1..-1] if controller_name.start_with?('/')
    action_name ||= 'index'
    message = "ACL: #{controller_name}##{action_name} => "

    Bizside::Acl::AccessControlUtils::role_keys.each do |role_key|
      access_control = Bizside::Acl::AccessControlUtils::get_access_control(role_key)

      # コントローラの定義を取得
      controller_value = access_control[controller_name]
      next unless controller_value.present?
  
      # アクションの定義を取得
      if controller_value.is_a?(String)
        action_value = controller_value
      elsif controller_value.is_a?(Array)
        action_value = controller_value
      elsif controller_value.is_a?(TrueClass)
        action_value = true
      elsif controller_value.is_a?(FalseClass)
        action_value = false
      else
        action_value = controller_value[action_name]
        action_value = controller_value['index'] if action_value.nil?
        if action_value.is_a?(Hash)
          action_value = controller_value[action_value['same_as']] if action_value['same_as'].present?
        end
      end

      next if action_value.nil?

      # アクセス定義を確認
      role = eval(role_key)
      if role
        if action_value.is_a?(String)
          ret = role.instance_eval(action_value)
        elsif action_value.is_a?(Array)
          action_value.each do |judge|
            ret = role.instance_eval(judge)
            break unless ret
          end
        elsif action_value.is_a?(FalseClass)
          ret = false
        else
          ret = true
        end
      else
        ret = false
      end

      unless ret      
        Bizside.logger.debug message + 'false'
        return false
      end

    end

    Bizside.logger.debug message + 'true'
    true
  end
end