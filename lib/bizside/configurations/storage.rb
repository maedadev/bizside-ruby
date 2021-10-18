module Bizside
  module Configurations
    module Storage

      def storage
        if @storage.nil?
          configfile = ENV['STORAGE_CONFIG_FILE'] ? ENV['STORAGE_CONFIG_FILE'] : default_configfile

          if File.exist?(configfile)
            config = ERB.new(File.read(configfile), 0, '-').result
            @storage = Bizside::Config.new(YAML.load(config)[Bizside.env])
          else
            @storage = Bizside::Config.new
          end
        end

        @storage
      end

      private

      def default_configfile
        File.join('config', 'aws.yml')
      end

    end
  end
end
