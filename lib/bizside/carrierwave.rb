# 日本語ファイル名のまま保存
CARRIERWAVE_SANITIZE_REGEXP = /[^[:word:]①-⑨【】「」（）・＆、　 \(\)\.\-\+]/
CarrierWave::SanitizedFile.sanitize_regexp = CARRIERWAVE_SANITIZE_REGEXP

module Bizside
  class CarrierwaveStringIO < StringIO
    attr_accessor :original_filename
    attr_accessor :content_type
    attr_accessor :file_size

    def path
      original_filename
    end
  end
end

CarrierWave.configure do |config|
  database_yml = ERB.new(File.read(File.join('config', 'database.yml')), 0, '-').result
  database = YAML.load(database_yml)[Bizside.env]['database']

  config.root = File.join('/data', Bizside.config.add_on_name, database)

  if Bizside.config.storage.fog?
    require 'carrierwave/storage/fog'
    require 'fog/aws'

    # fog の場合は、相対パス
    config.root = config.root[1..-1]

    credentials = Bizside.config.storage.fog.credentials.to_h.symbolize_keys
    if credentials[:use_iam_profile]
      credentials = credentials.merge(role_session_name: Bizside.config.add_on_name)
    end
    config.fog_credentials = credentials

    config.fog_directory = Bizside.config.storage.fog.container
    config.fog_public = false
    config.storage = :fog
  end

end
