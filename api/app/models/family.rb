class Family < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :relation

  belongs_to :user
  belongs_to :creator

  # 作品情報の作成・編集・削除権限チェック
  # こども情報の作成・編集・削除権限チェック
  def self.edit_permission_check(family)
    # 「パパ・ママ」のみ
    family && [1, 2].include?(family.relation_id)
  end

  # こどもの家族の解除権限チェック
  def remove_family_permission_check(user_family)
    # パパ・ママは、自身以外解除可能。
    # パパ・ママ以外は自身とのつながりのみ解除可能
    if user_family && [1, 2].include?(user_family.relation_id)
      user_family.user_id != self.user_id
    else
      user_family.user_id == self.user_id
    end
  end
end
