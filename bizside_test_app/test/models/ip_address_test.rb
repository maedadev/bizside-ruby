require 'test_helper'

class IpAddressTest < ActiveSupport::TestCase
  def test_正当なIPv4アドレス
    valid_ip_addresses = %w[
      0.0.0.0
      99.99.99.99
      249.249.249.249
      255.255.255.255
      255.25.255.255
    ]

    valid_ip_addresses.each do |ip|
      ip_address = IpAddress.new(ip_address_v4: ip)
      assert ip_address.valid?
    end
  end

  def test_不正なIPv4アドレス
    invalid_ip_addresses = %w[
      0
      0.
      0.0
      0.0.
      0.0.0
      0.0.0.
      0.0.0.0.
      300.0.0.0
      0.300.0.0
      0.0.300.0
      0.0.0.300
      265.0.0.0
      0.265.0.0
      0.0.265.0
      0.0.0.265
      256.0.0.0
      0.256.0.0
      0.0.256.0
      0.0.0.256
    ]

    invalid_ip_addresses.each do |ip|
      ip_address = IpAddress.new(ip_address_v4: ip)
      assert ip_address.invalid?
    end
  end

  def test_正当なcidr形式のIPアドレス
    valid_cidr_ip_addresses = %w[
      0.0.0.0/0
      99.99.99.99/16
      249.249.249.249/22
      255.255.255.255/24
      255.25.255.255/32
    ]

    valid_cidr_ip_addresses.each do |ip|
      ip_address = IpAddress.new(ip_address_cidr: ip)
      assert ip_address.valid?
    end
  end

  def test_不正なcidr形式のIPアドレス
    invalid_cidr_ip_addresses = %w[
      0.0.0.0/33
      99.99.99.99/48
      249.249.249.249/128
      255.255.255.255/255
      255.25.255.255/256
    ]

    invalid_cidr_ip_addresses.each do |ip|
      ip_address = IpAddress.new(ip_address_cidr: ip)
      assert ip_address.invalid?
    end
  end

  def test_cidrオプションがfalseのときcidr形式なら不正
    valid_cidr_ip_addresses = %w[
      0.0.0.0/0
      99.99.99.99/16
      249.249.249.249/22
      255.255.255.255/24
      255.25.255.255/32l
    ]

    valid_cidr_ip_addresses.each do |ip|
      ip_address = IpAddress.new(ip_address_v4: ip)
      assert ip_address.invalid?
    end
  end

  def test_IPv6は不正とする
    valid_ipv6_addresses = %w[
      ::
      ::1
      fe00::1
      2001:1111:2222:abcd:0000:0000:0000:0000
      2001:1111:2222:abcd::
      2001:470:c:1389::2
      2001:D3::2AB:11:FE25:8B5D
    ]

    valid_ipv6_addresses.each do |ip|
      ip_address = IpAddress.new(ip_address_v4: ip)
      assert ip_address.invalid?
    end
  end
end