class Work < ApplicationRecord
  include Rails.application.routes.url_helpers
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :scope

  belongs_to :creator
  has_many_attached :images

  # バリデーション -------------------------------------------------
  # 単項目共通チェック
  with_options presence: { message: '必須入力です'} do
    validates :scope_id
    validates :creator_id
  end

  # 単項目チェック
  validates :date, presence: { message: '必須入力です'}, if: :date_blank?
    # 必須入力チェックの条件（暗黙の型変換によって入力値がnillになる場合の考慮）
    def date_blank?
      self.date.nil? && self.date_before_type_cast.blank?
    end
  validates :date, date_format: true
  validates :title,
    length: { maximum: 40, message: '40字以内で入力してください' }
  validates :description,
    length: { maximum: 40, message: '40字以内で入力してください' }
  validates :scope_id,
    numericality: {
      greater_than_or_equal_to: 1, less_than_or_equal_to: 3,
      message: '選択肢から指定してください'
    }
  
  # 相関チェック
  validate :creator_exists?
  def creator_exists?
    errors.add(:creator_id, '作成者が存在しません') unless Creator.exists?(creator_id)
  end
  # ----------------------------------------------------------------


  # 画像データのURL取得
  def images_url
    if images.attached?
      i = 0
      count = images.length
      imageList = []
      while i < count
        imageList.push(url_for(images[i]))
        i += 1
      end
      return imageList
    else
      return nil
    end
  end

end
