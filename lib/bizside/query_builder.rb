module Bizside
  class QueryBuilder

    attr_reader :sql, :params

    def initialize
      @sql = ''
      @params = []
      @indent = 0
    end

    def append(*args)
      if args.size == 1
        if args[0].is_a?(Array)
          append(*args[0])
        elsif args[0].is_a?(QueryBuilder)
          append(args[0].to_array)
        else
          append_sql(args[0])
        end
      else
        args.each_with_index do |arg, i|
          if i == 0
            append_sql(arg)
          else
            @params << arg
          end
        end
      end

      self
    end

    def and(*args)
      append_sql('and (')

      if block_given?
        @indent += 1
        yield self
        @indent -= 1
      else
        append(*args)
      end

      append_sql(')')
    end

    def or(*args)
      append_sql('or (')

      if block_given?
        @indent += 1
        yield self
        @indent -= 1
      else
        append(*args)
      end

      append_sql(')')
    end

    def to_array
      [@sql] + @params
    end

    def to_a
      to_array
    end

    private

    def append_sql(sql)
      @indent.times { @sql << '  ' }
      @sql << sql
      @sql << "\n"
    end
  end
end
