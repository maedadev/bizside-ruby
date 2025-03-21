module Bizside
  module Configurations
    module Storage

      def storage
        return @storage if defined? @storage

        configfile = ENV['STORAGE_CONFIG_FILE'] ? ENV['STORAGE_CONFIG_FILE'] : default_configfile
        @storage = if File.exist?(configfile)
            text = ERB.new(File.read(configfile), 0, '-').result
            entire_config = YAML.respond_to?(:unsafe_load) ? YAML.unsafe_load(text) : YAML.load(text)
            Bizside::Config.new(entire_config[Bizside.env])
          else
            Bizside::Config.new
          end
      end

      private

      def default_configfile
        File.join('config', 'aws.yml')
      end

    end
  end
end
