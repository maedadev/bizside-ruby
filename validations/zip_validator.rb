class ZipValidator < ActiveModel::EachValidator

  def initialize(options = {})
    super(options)
    @other = options[:other]
  end

  def validate_each(record, attribute, value)
    zip1 = value
    zip2 = get_other_value(record)

    return if (zip1.nil? or zip1.empty?) and (zip2.nil? or zip2.empty?)

    unless validate_zip(zip1, zip2)
      record.errors[attribute] << I18n.t('errors.messages.zip')
      return
    end
  end

  private

  def validate_zip(zip1, zip2)
    return false unless zip1
    return false unless zip1.match(/^[0-9|０-９]{3}$/)

    return false unless zip2
    return false unless zip2.match(/^[0-9|０-９]{4}$/)

    true
  end

  def get_other_value(record)
    record.__send__(@other)
  end
end
