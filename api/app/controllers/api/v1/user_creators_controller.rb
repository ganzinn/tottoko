class Api::V1::UserCreatorsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :user_check

  def create
    @family_creator_form = FamilyCreatorForm.new(family_creator_form_params.except(:user_id))
    if @family_creator_form.valid?
      @family_creator_form.save!
      render status: 201, json: {success: true }
    else
      render status: 422, json: {success: false, message: @family_creator_form.errors}
    end
  end

  def index
    @user_creators = Creator.where(
      id: Family.where(user_id: current_api_v1_user.id).select(:creator_id)
    )
  end

  private

  def family_creator_form_params
    params.permit(
      :user_id,
      :creator_name,
      :creator_date_of_birth,
      :creator_gender_id,
      :relation_id
    ).merge(
      current_user_id: current_api_v1_user.id
    )
  end

  def user_check
    if current_api_v1_user.id != family_creator_form_params[:user_id].to_i
      render status: 401, json: {success: false, message: 'Unauthorized'}
    end
  end
end
