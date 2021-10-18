require 'bizside/cache_util'

class Bizside::CacheUtils 
  extend Bizside::CacheUtil
  
  def self.cache
    Rails.cache
  end

end
