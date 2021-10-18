module Bizside
  module Configurations
    module Prefix

      def prefix(ending_slash = false)
        ret = ENV['X-BIZSIDE-PREFIX']

        if ret.to_s.empty?
          ret = self.prefix? ? self['prefix'] : '/'
        end

        if ret != '/'
          if ending_slash
            ret = ret + '/' unless ret.end_with?('/')
          else
            ret = ret[0..-2] if ret.end_with?('/')
          end
        end
        
        ret
      end

    end
  end
end
