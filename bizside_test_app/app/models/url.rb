# UrlValidatorのテスト用モデル
require 'bizside/validations'

class Url < ActiveRecord::Base
  validates :url, url: true
  validates :url_without_schema, url: {with_schema: false}
end