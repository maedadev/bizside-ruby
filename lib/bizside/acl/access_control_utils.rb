# アクセス制御のユーティリティクラス
class Bizside::Acl::AccessControlUtils
  
  @@access_control = nil

  def self.init(reload = false)
    if reload or @@access_control.nil?
      @@access_control = {}
      config_files = Bizside.config.acl.config_files? ? Bizside.config.acl.config_files : ['config/acl.yml']
      config_files.each do |config|
        merge(config)
      end
    end
  end

  def self.merge(filename)
    entire_config = YAML.respond_to?(:unsafe_load_file) ? YAML.unsafe_load_file(filename) : YAML.load_file(filename)
    entire_config.each do |roll_key, values|
      @@access_control[roll_key] ||= {}
      @@access_control[roll_key].merge!(values)
    end
  end

  def self.role_keys
    # Railsを使用 かつ 開発環境の場合はリロードする
    init(Bizside.rails_env&.development?)

    @@access_control.keys.sort
  end

  def self.get_access_control(roll_key)
    @@access_control[roll_key]
  end
  
end
