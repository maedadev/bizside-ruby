# UrlValidatorのテスト用モデル
require 'bizside/validations'

class Url < ApplicationRecord
  validates :url, url: true
  validates :url_without_schema, url: {with_schema: false}
end