require 'ipaddress'

class IpAddressValidator < ActiveModel::EachValidator

  def initialize(options = {})
    super(options)
  end

  def validate_each(record, attribute, value)
    return if (value.nil? or value.empty?)

    begin
      if options[:cidr]
        IPAddress::IPv4.new(value)
      else
        raise unless IPAddress::valid_ipv4?(value)
      end
    rescue
      record.errors.add(attribute, options[:message] || "はIPアドレスとして正しくありません。")
    end
  end
end
