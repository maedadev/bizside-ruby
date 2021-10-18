class CollectionPresenceValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    value.each do |v|
      if v.respond_to?(:deleted?)
        next if v.deleted?
      end

      return if v.present?
    end

    record.errors.add(attribute, :empty)
  end

end
