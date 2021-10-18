require 'bizside/cache/entry'

module Bizside
  module Cache
    class Store
      
      attr_reader :options
      
      def initialize(options = nil)
        @options = options ? options.dup : {}
      end
  
      def fetch(name, options = nil)
        if block_given?
          options = merged_options(options)
          key = namespaced_key(name, options)

          cached_entry = find_cached_entry(key, name, options) unless options[:force]
          entry = handle_expired_entry(cached_entry, key, options)

          if entry
            get_entry_value(entry, name, options)
          else
            save_block_result_to_cache(name, options) { |_name| yield _name }
          end
        else
          read(name, options)
        end
      end

      def read(name, options = nil)
        options = merged_options(options)
        key = namespaced_key(name, options)
        instrument(:read, name, options) do |payload|
          entry = read_entry(key, options)
          if entry
            if entry.expired?
              delete_entry(key, options)
              payload[:hit] = false if payload
              nil
            else
              payload[:hit] = true if payload
              entry.value
            end
          else
            payload[:hit] = false if payload
            nil
          end
        end
      end

      def read_multi(*names)
        options = names.extract_options!
        options = merged_options(options)
        results = {}
        names.each do |name|
          key = namespaced_key(name, options)
          entry = read_entry(key, options)
          if entry
            if entry.expired?
              delete_entry(key, options)
            else
              results[name] = entry.value
            end
          end
        end
        results
      end

      def fetch_multi(*names)
        options = names.extract_options!
        options = merged_options(options)
        results = read_multi(*names, options)

        names.each_with_object({}) do |name, memo|
          memo[name] = results.fetch(name) do
            value = yield name
            write(name, value, options)
            value
          end
        end
      end

      def write(name, value, options = nil)
        options = merged_options(options)

        instrument(:write, name, options) do
          entry = Bizside::Cache::Entry.new(value, options)
          write_entry(namespaced_key(name, options), entry, options)
        end
      end

      def delete(name, options = nil)
        options = merged_options(options)

        instrument(:delete, name) do
          delete_entry(namespaced_key(name, options), options)
        end
      end

      def exist?(name, options = nil)
        options = merged_options(options)

        instrument(:exist?, name) do
          entry = read_entry(namespaced_key(name, options), options)
          (entry && !entry.expired?) || false
        end
      end

      def delete_matched(matcher, options = nil)
        raise NotImplementedError.new("does not support delete_matched")
      end

      def increment(name, amount = 1, options = nil)
        raise NotImplementedError.new("does not support increment")
      end

      def decrement(name, amount = 1, options = nil)
        raise NotImplementedError.new("does not support decrement")
      end

      def cleanup(options = nil)
        raise NotImplementedError.new("does not support cleanup")
      end

      def clear(options = nil)
        raise NotImplementedError.new("does not support clear")
      end

      protected
      
      def key_matcher(pattern, options)
        prefix = options[:namespace].is_a?(Proc) ? options[:namespace].call : options[:namespace]
        if prefix
          source = pattern.source
          if source.start_with?('^')
            source = source[1, source.length]
          else
            source = ".*#{source[0, source.length]}"
          end
          Regexp.new("^#{Regexp.escape(prefix)}:#{source}", pattern.options)
        else
          pattern
        end
      end

      def read_entry(key, options)
        raise NotImplementedError.new
      end

      def write_entry(key, entry, options)
        raise NotImplementedError.new
      end

      def delete_entry(key, options)
        raise NotImplementedError.new
      end

      private
      
      def merged_options(call_options)
        if call_options
          options.merge(call_options)
        else
          options.dup
        end
      end

      def expanded_key(key)
        return key.cache_key.to_s if key.respond_to?(:cache_key)

        case key
        when Array
          if key.size > 1
            key = key.collect{|element| expanded_key(element)}
          else
            key = key.first
          end
        when Hash
          key = key.sort_by { |k,_| k.to_s }.collect{|k,v| "#{k}=#{v}"}
        end

        key.to_param
      end

      def namespaced_key(key, options)
        key = expanded_key(key)
        namespace = options[:namespace] if options
        prefix = namespace.is_a?(Proc) ? namespace.call : namespace
        key = "#{prefix}:#{key}" if prefix
        key
      end

      def instrument(operation, key, options = nil)
        payload = { :key => key }
        payload.merge!(options) if options.is_a?(Hash)
        ActiveSupport::Notifications.instrument("cache_#{operation}.active_support", payload){ yield(payload) }
      end

      def find_cached_entry(key, name, options)
        instrument(:read, name, options) do |payload|
          payload[:super_operation] = :fetch if payload
          read_entry(key, options)
        end
      end

      def handle_expired_entry(entry, key, options)
        if entry && entry.expired?
          race_ttl = options[:race_condition_ttl].to_i
          if (race_ttl > 0) && (Time.now.to_f - entry.expires_at <= race_ttl)
            entry.expires_at = Time.now + race_ttl
            write_entry(key, entry, :expires_in => race_ttl * 2)
          else
            delete_entry(key, options)
          end
          entry = nil
        end
        entry
      end

      def get_entry_value(entry, name, options)
        instrument(:fetch_hit, name, options) { |payload| }
        entry.value
      end

      def save_block_result_to_cache(name, options)
        result = instrument(:generate, name, options) do |payload|
          yield(name)
        end

        write(name, result, options)
        result
      end
      
    end
  end
end