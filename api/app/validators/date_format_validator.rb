class DateFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      Date.parse value if value.present?
    rescue ArgumentError
      record.errors.add(attribute, '適切な日付の形式で指定してください')
    end
  end
end