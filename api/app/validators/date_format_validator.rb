class DateFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.class.ancestors.include?(ApplicationRecord)
      value = record.send("#{attribute}_before_type_cast")
    end
    begin
      Date.parse value if value.present?
    rescue ArgumentError
      record.errors.add(attribute, '適切な日付の形式で指定してください')
    end
  end
end