class DateFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value = record.send("#{attribute}_before_type_cast")
    begin
      Date.parse value if value.present?
    rescue ArgumentError
      record.errors.add(attribute, '適切な日付の形式で指定してください')
    end
  end
end