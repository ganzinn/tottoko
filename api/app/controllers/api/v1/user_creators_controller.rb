class Api::V1::UserCreatorsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def create
    @family_creator_form = FamilyCreatorForm.new(family_creator_form_params)
    if @family_creator_form.valid?
      @family_creator_form.save
      render status: 201, json: {success: true }
    else
      render status: 400, json: {success: false, message: @family_creator_form.errors}
    end
  end

  def index
    if current_api_v1_user.id != params[:user_id].to_i
      render status: 401, json: {success: false, message: 'Unauthorized'}
    end
    @user_creators = Creator.where(
      id: Family.where(user_id: current_api_v1_user.id).select(:creator_id)
    )
  end

  private

  def family_creator_form_params
    params.permit(
      :creator_name,
      :creator_date_of_birth,
      :creator_gender_id,
      :relation_id
    ).merge(
      user_id: current_api_v1_user.id
    )
  end
end
