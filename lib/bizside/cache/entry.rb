module Bizside
  module Cache
    class Entry
      DEFAULT_COMPRESS_LIMIT = 16.kilobytes

      def initialize(value, options = {})
        if should_compress?(value, options)
          @value = compress(value)
          @compressed = true
        else
          @value = value
        end

        @created_at = Time.now.to_f
        @expires_in = options[:expires_in]
        @expires_in = @expires_in.to_f if @expires_in
      end

      def value
        convert_version_4beta1_entry! if defined?(@v)
        compressed? ? uncompress(@value) : @value
      end

      def expired?
        convert_version_4beta1_entry! if defined?(@v)
        @expires_in && @created_at + @expires_in <= Time.now.to_f
      end

      def expires_at
        @expires_in ? @created_at + @expires_in : nil
      end

      def expires_at=(value)
        if value
          @expires_in = value.to_f - @created_at
        else
          @expires_in = nil
        end
      end

      def size
        if defined?(@s)
          @s
        else
          case value
          when NilClass
            0
          when String
            @value.bytesize
          else
            @s = Marshal.dump(@value).bytesize
          end
        end
      end

      def dup_value!
        convert_version_4beta1_entry! if defined?(@v)

        if @value && !compressed? && !(@value.is_a?(Numeric) || @value == true || @value == false)
          if @value.is_a?(String)
            @value = @value.dup
          else
            @value = Marshal.load(Marshal.dump(@value))
          end
        end
      end

      private
      
      def should_compress?(value, options)
        if value && options[:compress]
          compress_threshold = options[:compress_threshold] || DEFAULT_COMPRESS_LIMIT
          serialized_value_size = (value.is_a?(String) ? value : Marshal.dump(value)).bytesize

          return true if serialized_value_size >= compress_threshold
        end

        false
      end

      def compressed?
        defined?(@compressed) ? @compressed : false
      end

      def compress(value)
        Zlib::Deflate.deflate(Marshal.dump(value))
      end

      def uncompress(value)
        Marshal.load(Zlib::Inflate.inflate(value))
      end

      def convert_version_4beta1_entry!
        if defined?(@v)
          @value = @v
          remove_instance_variable(:@v)
        end

        if defined?(@c)
          @compressed = @c
          remove_instance_variable(:@c)
        end

        if defined?(@x) && @x
          @created_at ||= Time.now.to_f
          @expires_in = @x - @created_at
          remove_instance_variable(:@x)
        end
      end
    end
  end
end