# ZipValidatorのテスト用モデル
require 'bizside/validations'

class ZipCode < ApplicationRecord
  validates :zip1, zip: { other: :zip2 }
end
