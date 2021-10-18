module Bizside
  module CacheUtil
    
    def fetch(key, options = {})
      if block_given?
        action = cache.exist?(key) ? 'READ' : 'WRITE'
        output_log "#{action} CACHE: #{key}"
        cache.fetch(key, options) do
          yield
        end
      else
        output_log "READ CACHE: #{key}" 
        cache.fetch(key, options)
      end
    end

    def delete(key)
      output_log "CLEAR CACHE: #{key}"
      cache.delete(key)
    end

    def delete_matched(matcher)
      output_log "CLEAR CACHE: #{matcher}"
      cache.delete_matched(matcher)
    end

    def clear(options = nil)
      output_log "CLEAR ALL CACHE"
      cache.clear(options)
    end

    def cache
      raise 'サブクラスで実装'
    end
    
    private
    
    def output_log message
      if defined?(Rails) && Rails.logger
        Rails.logger.info message
      else
        puts message
      end
    end

  end
end
