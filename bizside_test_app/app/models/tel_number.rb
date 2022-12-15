# TelValidatorのテスト用モデル
require 'bizside/validations'

class TelNumber < ApplicationRecord
  validates :tel, tel: true
end
