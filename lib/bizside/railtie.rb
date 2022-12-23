require_relative 'coverage/launch'
Bizside::CoverageLaunch.load()

module Bizside
  class Railtie < ::Rails::Railtie

    # ロケールファイル
    initializer 'bizside-i18n' do |app|
      Bizside::Railtie.instance_eval do
        pattern = pattern_from(app.config.i18n.available_locales)
        add("rails/locales/#{pattern}.yml")
      end
    end

    # ビューのヘルパーメソッド
    initializer 'view_helper' do
      require_relative 'view_helper'

      ActiveSupport.on_load(:action_view) do
        include Bizside::ViewHelper
      end
    end

    # 警告バリデーション
    if Bizside.config.warning_validation.enabled?
      require_relative 'warning'

      initializer 'warning_validation' do
        ActiveSupport.on_load :active_record do
          include Bizside::Warning
        end
      end
    end

    if Bizside.config.user_agent.enabled?
      if Bizside.config.user_agent.to_h.has_key?('use_variant')
        raise "ERROR: 'use_variant' is obsolete. Delete it from config/bizside.yml"
      end

      require_relative 'user_agent'

      initializer 'user_agent' do
        ActiveSupport.on_load(:action_controller) do
          include Bizside::UserAgent::ControllerHelper
        end
      end
    end

    if Bizside.config.acl.enabled?
      require_relative 'acl'

      initializer 'acl' do
        ActiveSupport.on_load(:action_controller) do
          include Bizside::Acl::ControllerHelper
        end
        ActiveSupport.on_load(:action_view) do
          include Bizside::Acl::AvailableHelper
        end
      end
    end

    unless Bizside.config.active_record_logger.enabled?
      initializer 'active_record_logger' do
        ActiveSupport.on_load(:active_record) do
          require_relative 'active_record_logger'
        end
      end
    end

    protected

    def self.add(pattern)
      files = Dir[File.join(File.dirname(__FILE__), '../..', pattern)]
      I18n.load_path.concat(files)
    end

    def self.pattern_from(args)
      array = Array(args || [])
      array.blank? ? '*' : "{#{array.join ','}}"
    end

  end
end
