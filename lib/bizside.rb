require 'logger'
require 'yaml'
require 'active_support'
require 'active_support/core_ext'

require 'bizside/version'
require 'bizside/config'
require 'bizside/gengou'
require 'bizside/job_utils'
require 'bizside/query_builder'
require 'bizside/sql_utils'
require 'bizside/string_utils'
require 'bizside/user_agent'
require 'bizside/yes'

module Bizside

  # Railsがロードできる場合はRails.envを返し、ロードできない場合はnilを返します。
  def self.rails_env
    defined?(Rails) && Rails.env
  end

  def self.env
    rails_env || ENV['RAILS_ENV'] || 'development'
  end

  @@_version_info = nil
  def self.version_info
    if @@_version_info.nil?
      release_tag_file = "/var/#{Bizside.config.add_on_name}/shared/RELEASE_TAG"
      if File.exist?(release_tag_file)
        @@_version_info = File.read(release_tag_file).strip
      else
        if Dir.exist?('.git')
          info = `git describe`.strip.split('-')
          @@_version_info = info[0] ? "#{info[0]}-#{info[1]}" : '0.0.0-0'
          @@_version_info << "-p#{info[2]}" if info[2].to_i > 0
        else
          @@_version_info = '0.0.0-0'
        end
      end
    end

    @@_version_info
  end

  @@_config = nil
  def self.config
    if @@_config
      return @@_config unless Bizside.env == 'development'
    end

    configfile = ENV['CONFIG_FILE'] || File.join('config', 'bizside.yml')
    if File.exist?(configfile)
      @@_config = Bizside::Config.new(YAML.load_file(configfile)[Bizside.env])
    else
      raise "設定ファイルの #{configfile} は必須です。"
    end
  end

  def self.logger
    if defined?(Rails) && Rails.logger
      Rails.logger
    else
      @logger ||= ::Logger.new($stdout)
    end
  end
end

require 'bizside/shib_utils'

require 'bizside/acl' if Bizside.config.acl.enabled?
require 'bizside/warning' if Bizside.config.warning_validation.enabled?
require 'bizside/user_agent' if Bizside.config.user_agent.enabled?
require 'bizside/file_converter' if Bizside.config.jod_converter.enabled?

require 'bizside/audit_log'
require 'bizside/show_exceptions'

if defined?(Rails)
  require 'bizside/cache_utils'
  require 'bizside/engine' unless Bizside.config.use_best_practices?
  require 'bizside/railtie'
end

unless Bizside.config.within_bizside_namespace?
  %w[
    CarrierwaveStringIO CronValidator Gengou JobUtils QueryBuilder
    SqlUtils RecordHasWarnings StringUtils UserAgent Yes
  ].each do |class_name|
    bizside_class_name = "::Bizside::#{class_name}"
    next unless self.class.const_defined?(bizside_class_name)

    self.class.const_set class_name, self.class.const_get(bizside_class_name)
  end
end
