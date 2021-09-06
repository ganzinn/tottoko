class FamilyCreatorForm
  include ActiveModel::Model
  attr_accessor :current_user_id,
                :relation_id,
                :creator_name,
                :creator_date_of_birth,
                :creator_gender_id

  # バリデーション -------------------------------------------------
  # 共通単体チェック
  with_options presence: { message: '必須入力です'} do
    validates :creator_name
    validates :creator_date_of_birth
    validates :creator_gender_id
    validates :relation_id
  end

  # 単体チェック
  validates :creator_name,
    length: { maximum: 40, message: '40字以内で指定してください' }
  validates :creator_date_of_birth,
    date_format: true
  validates :creator_gender_id,
    numericality: {
      greater_than_or_equal_to: 1, less_than_or_equal_to: 3,
      message: '選択肢から指定してください'
    }
  validates :relation_id,
    numericality: {
      # 「パパ・ママ」のみ
      greater_than_or_equal_to: 1, less_than_or_equal_to: 2,
      message: '選択肢から指定してください'
    }
  # ----------------------------------------------------------------
  
  def save!
    ApplicationRecord.transaction do
      creator = Creator.create!(
        name: creator_name,
        date_of_birth: creator_date_of_birth,
        gender_id: creator_gender_id
      )
      Family.create!(
        user_id: current_user_id,
        creator_id: creator.id,
        relation_id: relation_id
      )
    end
  end
end
