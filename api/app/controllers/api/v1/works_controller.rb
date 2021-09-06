class Api::V1::WorksController < ApplicationController
  before_action :authenticate_api_v1_user!, only: [:update, :destroy]
  before_action :set_work,                  only: [:update, :destroy, :show]
  before_action :edit_permission_check,     only: [:update, :destroy]

  def show
    @family = Family.find_by(user_id: current_api_v1_user.id, creator_id: @work.creator_id) if api_v1_user_signed_in?

    # 作品の閲覧権限チェック
    unless @work.scope_id == 3 || (@family && @work.scope.targets.include?(@family.relation_id))
      render status: 401, json: {success: false, message: 'Unauthorized'} and return
    end
  end

  def update
    if @work.update(work_params.except(:id))
      render status: 200, json: {success: true }
    else
      render status: 422, json: {success: false, message: @work.errors}
    end
  end

  def destroy
    if @work.destroy
      render status: 200, json: {success: true }
    else
      render status: 422, json: {success: false, message: @work.errors}
    end
  end

  private

  def set_work
    @work = Work.find(work_params[:id])
  end

  # 編集・削除権限チェック
  def edit_permission_check
    family = Family.find_by(user_id: current_api_v1_user.id, creator_id: @work.creator_id)
    unless Family.edit_permission_check(family)
      render status: 401, json: {success: false, message: 'Unauthorized'} and return
    end
  end

  def work_params
    params.permit(
      :id,
      :date,
      :title,
      :description,
      :scope_id,
      images: []
    )
  end
end
