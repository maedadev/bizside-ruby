class UrlValidator < ActiveModel::EachValidator

  def initialize(options = {})
    super(options)
    if options.key?(:with_schema)
      @with_schema = options[:with_schema]
    else
      @with_schema = true
    end
  end

  def validate_each(record, attribute, value)
    begin
      URI.parse(value)
    rescue URI::InvalidURIError
      record.errors[attribute] << (options[:message] || "はURLとして正しくありません。")
      return
    end
    
    if @with_schema
      unless value.start_with?('http://') or value.start_with?('https://')
        record.errors[attribute] << (options[:message] || "は http:// または https:// から始めてください。")
      end
    else
      if value.start_with?('http://') or value.start_with?('https://')
        record.errors[attribute] << (options[:message] || "は http:// または https:// を含めないでください。")
      end
    end
  end
end
