# IpAddressValidatorのテスト用モデル
require 'bizside/validations'

class IpAddress < ActiveRecord::Base
  validates :ip_address_v4, ip_address: true
  validates :ip_address_cidr, ip_address: {cidr: true}
end