class FamilyUserForm
  include ActiveModel::Model
  attr_accessor :user_id,
                :user_email,
                :creator_id,
                :relation_id

  # バリデーション -------------------------------------------------
  # 共通単体チェック
  with_options presence: { message: '必須入力です'} do
    validates :user_email
    validates :creator_id
    validates :relation_id
  end

  # 単体チェック
  validates :relation_id,
    numericality: {
      greater_than_or_equal_to: 1, less_than_or_equal_to: 8,
      message: '選択肢から指定してください'
    }

  # 相関チェック（存在チェック）
  validate :user_email_presence?, if: -> { user_email.present? }
  def user_email_presence?
    errors.add( :user_email, 'must exist' ) unless User.exists?(email: user_email)
  end
  validate :creator_presence?, if: -> { creator_id.present? }
  def creator_presence?
    errors.add( :creator_id, 'must exist' ) unless Creator.exists?(creator_id)
  end
  
  # ----------------------------------------------------------------

  def save
    return false if invalid?
    user_id = User.select(:id).find_by(email: user_email).id
    Family.create(
      user_id: user_id,
      creator_id: creator_id,
      relation_id: relation_id
    )
  end
end
