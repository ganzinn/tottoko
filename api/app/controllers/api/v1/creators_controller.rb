class Api::V1::CreatorsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_creator

  def show
    @family = Family.find_by(user_id: current_api_v1_user.id, creator_id: creator_params[:id])
    if @creator && @family
      @creator_families = Family.where(creator_id: creator_params[:id]).includes(:user)
    else
      render status: 401, json: {success: false, message: 'Unauthorized'} and return
    end
  end

  def update
    if @creator.update(creator_params.except(:id))
      render status: 200, json: {success: true }
    else
      render status: 422, json: {success: false, message: @creator.errors}
    end
  end

  def destroy
    if @creator.destroy
    render status: 200, json: {success: true }
    else
      render status: 422, json: {success: false, message: @creator.errors}
    end
  end

  private

  def set_creator
    @creator = Creator.find(creator_params[:id])
  end

  def creator_params
    params.permit(
      :id,
      :name,
      :date_of_birth,
      :gender_id
    )
  end
end
