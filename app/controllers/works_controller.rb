class WorksController < ApplicationController
  before_action :authenticate_user!,    only: [:edit, :update, :destroy]
  before_action :set_work,              only: [:edit, :update, :destroy, :show]
  before_action :edit_permission_check, only: [:edit, :update, :destroy]

  def show
    @family = Family.find_by(user_id: current_user.id, creator_id: @work.creator_id) if user_signed_in?

    # 閲覧権限チェック
    redirect_to root_path unless @work.scope_id == 3 || (@family && @work.scope.targets.include?(@family.relation_id))
  end

  def edit
  end

  def update
    if @work.update(work_params)
      redirect_to work_path(@work)
    else
      render :edit
    end
  end

  def destroy
    @work.destroy
    redirect_to root_path
  end

  private

  def set_work
    @work = Work.find(params[:id])
  end

  # 編集・削除権限チェック
  def edit_permission_check
    family = Family.find_by(user_id: current_user.id, creator_id: @work.creator_id)
    redirect_to root_path unless Family.edit_permission_check(family)
  end

  def work_params
    params.require(:work).permit(
      :date,
      :title,
      :description,
      :scope_id,
      :creator_id,
      images: []
    )
  end
end
