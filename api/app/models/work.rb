class Work < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :scope

  belongs_to :creator
  has_many_attached :images
end
