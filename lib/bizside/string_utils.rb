require 'nkf'

module Bizside
  class StringUtils
    Characters = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a

    def self.create_random_alpha_string length, case_sensitive = false
      chars = ('a'..'z').to_a
      chars += ('A'..'Z').to_a if case_sensitive
      chars_length = chars.length

      length.times.map { chars[rand(chars_length)] }.join
    end

    def self.create_random_string(number)
      (Array.new(number.to_i) do
        Characters[rand(Characters.size)]
      end
      ).join
    end

    def self.to_hiragana(s)
      return s if is_empty(s)
      NKF::nkf('-Ww --hiragana', s)
    end

    def self.to_katakana(s)
      return s if is_empty(s)
      NKF::nkf('-Ww --katakana', s)
    end

    def self.to_zen(s)
      return s if is_empty(s)
      NKF::nkf('-WwXm0', s)
    end

    def self.to_han(s)
      return s if is_empty(s)
      NKF::nkf('-Wwxm0Z0', s)
    end

    def self.sjis_to_utf8(s)
      NKF.nkf('-Swx', s)
    end

    def self.utf8_to_sjis(s)
      NKF.nkf('-Wsx', s)
    end

    def self.is_empty(s)
      s.nil? or s.empty?
    end

    def self.equal(s1, s2)
      if is_empty(s1) and is_empty(s2)
        true
      else
        s1 == s2
      end
    end

    def self.current_time_string(now = nil)
      now = Time.now unless now
      now.instance_eval { '%s%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round] }
    end

    def self.is_user_password(value,minimum,maximum)
      value =~ /^[!-~]{#{minimum},#{maximum}}$/u
    end

    def self.is_not_user_password(value,minimum,maximum)
       ! is_user_password(value,minimum,maximum)
    end

    def self.is_login_id(value)
      return nil if value =~ /\.{2,}/
      value =~ /^[0-9a-z_\.\-]{1,50}$/u
    end

    def self.is_not_login_id(value)
      ! is_login_id(value)
    end

    # HTMLタグを除去した文書を返す
    def self.remove_html_tag(str)
      return nil unless str
      str=str.dup
      str.sub!(/<[^<>]*>/,"") while /<[^<>]*>/ =~ str
      str
    end

    # リッチテキストの改行を保ったまま、HTMLタグを除去した文書を返す
    def self.remove_rich_html_tag(str)
      return nil unless str

      ret = str.gsub(/<div[^>]*>/, "\n")
      ret = remove_html_tag(ret)
      ret
    end

    # 指定した長さのランダム英数字文字列を返す。a-zA-Z0-9。62種類。
    def self.rand_string(length = 8)
      ret = []
      length.times do |i|
        ret[i] = Characters[rand(Characters.size)]
      end
      ret = ret.join

      return ret if ret =~ /^(?=.*?[a-z])(?=.*?\d).*+$/iu

      # 英字と数字が最低1文字を含むランダム英数字文字列を返すようにする
      alphabets = ('a'..'z').to_a + ('A'..'Z').to_a
      numerics = (0..9).to_a
      ranges = (0...length).to_a
      ret[ranges.slice!(rand(ranges.size))] = alphabets[rand(alphabets.size)]
      ret[ranges.slice!(rand(ranges.size))] = numerics[rand(numerics.size)].to_s

      ret
    end

    # URLからクエリストリングを除外して文字列を返す。
    # https://www.example.com?foo=bar #=> https://www.example.com
    def self.exclude_query_string(string)
      return string unless string.include?("?")
      string[/^.*(?=\?)/]
    end

    # 複数個の全角スペースを１個に圧縮する
    def self.compress_doble_byte_space(string)
      return nil unless string
      string.gsub(/　+/, '　')
    end

    # 文字列中に含まれる全角ハイフンっぽい文字を、指定した文字に一括置換する
    def self.replace_char_like_hyphen_to(string, to: "\u30FC")
      # U+002D Hyphen-Minus
      # U+00AD Soft Hyphen
      # U+02D7 Modifier Letter Minus Sign
      # U+2010 Hyphen
      # U+2011 Non-Breaking Hyphen
      # U+2012 Figure Dash
      # U+2013 En Dash
      # U+2014 Em Dash
      # U+2015 Horizontal Bar
      # U+2043 Hyphen Bullet
      # U+2212 Minus Sign
      # U+2796 Heavy Minus Sign
      # U+30FC Katakana-Hiragana Prolonged Sound Mark
      # U+FE58 Small Em Dash
      # U+FE63 Small Hyphen-Minus
      # U+FF0D Fullwidth Hyphen-Minus
      # U+FF70 Halfwidth Katakana-Hiragana Prolonged Sound Mark
      string.gsub(
        /[\u002D\u00AD\u02D7\u2010\u2011\u2012\u2013\u2014\u2015\u2043\u2212\u2796\u30FC\uFE58\uFE63\uFF0D\uFF70]/,
        to
      )
    end
  end
end
