class Api::V1::FamiliesController < ApplicationController
  def create

    # 【Todo】権限チェック（ログインユーザー権限かつ追加対象ユーザーの関係性のチェック）

    family_user_form = FamilyUserForm.new(family_user_form_params.except(:id))
    if family_user_form.save
      render status: 201, json: {success: true }
    else
      render status: 422, json: {success: false, message: family_user_form.errors}
    end
  end

  def destroy
    target_user_family = Family.find(family_user_form_params[:id])

    # 【Todo】権限チェック（ログインユーザー権限かつ削除対象ユーザーの関係性のチェック）
    # current_user_family = Family.find_by(user_id: current_api_v1_user.id, creator_id: family_user_form_params[:creator_id])

    if target_user_family.destroy
      render status: 200, json: {success: true }
    else
      render status: 422, json: {success: false, message: target_user_family.errors}
    end
  end

  private

  def family_user_form_params
    params.permit(
      :id,
      :creator_id,
      :relation_id,
      :user_email
    )
  end
end
