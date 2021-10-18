module Bizside
  class SqlUtils

    # LIKE検索用に検索文字列をエスケープします。
    def self.escape_search(str)
      str.gsub(/\\/, '\\\\\\\\').gsub(/%/, '\%').gsub(/_/, '\_')
    end

    def self.like(columns, query_string, options = {})
      target_columns = columns
      unless target_columns.is_a?(Array)
        target_columns = [target_columns]
      end

      sql = []
      sql[0] = '('

      query_string.gsub(/　/, ' ').split.each_with_index do |s, i|
        like = self.escape_search(s)

        sql[0]  << ' or ' if i > 0
        sql[0] << '('

        target_columns.each_with_index do |column, j|
          sql[0] << ' or ' if j > 0
          sql[0] << "#{column} like ?"

          if options.fetch(:backward_match, false)
            sql << like + '%'
          elsif options.fetch(:forward_match, false)
            sql << '%' + like
          else
            sql << '%' + like + '%'
          end
        end

        sql[0] << ')'
      end

      sql[0]  << ')'
      sql
    end

  end
end
