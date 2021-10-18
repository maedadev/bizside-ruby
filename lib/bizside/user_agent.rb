module Bizside
  class UserAgent

    USER_AGENTS = [
      ANDROID_MOBILE = 'android',
      IPAD           = 'ipad',
      IPHONE         = 'iphone',
      PC             = 'pc',
      SMART_PHONE    = 'sp',
    ]

    def self.parse(http_user_agent)
      case http_user_agent
      when /Android.*Mobile/
        new(ANDROID_MOBILE, http_user_agent)
      when /iPhone/
        new(IPHONE, http_user_agent)
      when /iPad/
        new(IPAD, http_user_agent)
      else
        new(PC, http_user_agent)
      end
    end

    def initialize(name, http_user_agent = nil)
      @name = name if USER_AGENTS.include?(name)
      @name ||= PC
      @http_user_agent = http_user_agent
    end

    def name
      @name
    end

    def actual
      @actual ||= @http_user_agent ? self.class.parse(@http_user_agent) : self
    end

    def ipad?
      self.name == IPAD
    end

    def pc?
      self.name == PC
    end

    def windows?
      case @http_user_agent
      when /.*Windows.*/
        pc?
      else
        false
      end
    end

    def mac?
      case @http_user_agent
      when /.*Mac.*/
        pc?
      else
        false
      end
    end

    def sp?
      [ANDROID_MOBILE, IPHONE, SMART_PHONE].include?(self.name)
    end

    def iphone?
      self.name == IPHONE
    end

    def android_mobile?
      self.name == ANDROID_MOBILE
    end

    def priorities
      ret = []
      ret << self.name
      ret << SMART_PHONE if sp?
      ret << PC unless pc?
      ret
    end

    def ie?
      case @http_user_agent
      when /.* MSIE .* Windows .*/  #IE10以下
        true
      when /.*Windows.*Trident.*/   #IE11
        true
      else
        false
      end
    end

    def chrome?
      case @http_user_agent
      when /.* Chrome\/.*/
        true
      else
        false
      end
    end

  end
end

require_relative 'user_agent/controller_helper'
