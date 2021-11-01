require 'carrierwave'
require_relative 'carrierwave'

require_relative 'uploader/extension_whitelist'
require_relative 'uploader/filename_validator'
require_relative 'uploader/content_type_validator'

if defined?(Rails) && Rails.application.class.parent_name.eql?('BizsideTestApp')
  # not require 'uploader/exif'
else
  require_relative 'uploader/exif'
end

module Bizside
  # === storage.yml
  # storage.yml に fog エントリが定義されている場合、fog 参照先
  # のストレージの fog.container に保存します。
  #
  # storage.yml が存在しない・又は fog エントリがない場合はローカルに保存します。
  class FileUploader < CarrierWave::Uploader::Base

    include Bizside::Uploader::ExtensionWhitelist
    include Bizside::Uploader::FilenameValidator
    include Bizside::Uploader::ContentTypeValidator

    begin
      require 'mini_magick'
      include CarrierWave::MiniMagick
      include Bizside::Uploader::Exif
    rescue LoadError
      begin
        require 'rmagick'
        include CarrierWave::RMagick
        include Bizside::Uploader::Exif
      rescue LoadError
      end
    end

    if CarrierWave::SanitizedFile.sanitize_regexp != CARRIERWAVE_SANITIZE_REGEXP
      raise 'CarrierWave::SanitizedFile.sanitize_regexpの変更は禁止されました。'
    end
    CarrierWave::SanitizedFile.sanitize_regexp = /[\n\r]/ # CarrierWaveに自動でサニタイズさせず、別途 filename_validator でチェックする

    def downloaded_file
      Bizside.config.storage.fog? ? downloaded_file_from_fog(file.path) : file.path
    end

    private

    def downloaded_file_from_fog(path)
      Bizside.config.storage.fog.cache? ? download_file_from_fog_with_cache(path) : download_file_from_fog(path)
    end

    def download_file_from_fog(path)
      tmp_path = "/tmp/#{Bizside.config.add_on_name}-#{Bizside::StringUtils.current_time_string}-#{File.basename(path)}"
      raise "File download failed.(curl '#{file.url}' -o '#{tmp_path}')" unless system("curl '#{file.url}' -o '#{tmp_path}'")
      tmp_path
    end

    def download_file_from_fog_with_cache(path)
      cache_path = "/" + path
      unless File.exist?(cache_path)
        FileUtils.mkdir_p(File.dirname(cache_path))
        tmp_path = download_file_from_fog(path)
        raise "Failed to move file.(mv '#{tmp_path}' '#{cache_path}')" unless system("mv '#{tmp_path}' '#{cache_path}'")
      end
      cache_path
    end

  end
end
