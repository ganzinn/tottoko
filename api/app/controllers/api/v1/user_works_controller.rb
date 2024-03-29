class Api::V1::UserWorksController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :user_check

  def create
    family = Family.find_by(user_id: current_api_v1_user.id, creator_id: work_params[:creator_id])
    work = Work.new(work_params.except(:user_id))

    #子ども（creator）との関係が「パパ・ママ」でない場合
    unless Family.edit_permission_check(family)
      render status: 401, json: {success: false, message: 'Unauthorized'} and return
    end

    if work.valid?
      work.save!
      render status: 201, json: {success: true }
    else
      render status: 422, json: {success: false, message: work.errors}
    end
  end

  def index
    user_creator_ids = Family.where(user_id: current_api_v1_user.id).pluck(:creator_id)
    select_creator_ids = user_creator_ids

    # 表示する子ども(creator)の選択。クエリパラメータで絞り込み可能とする
    if params[:creator_id]
      if user_creator_ids.include?(work_params[:creator_id].to_i)
        select_creator_ids = work_params[:creator_id].to_i
      else
        render status: 404, json: {success: false, message: 'Not found'}
      end
    end

    # 対象作品の取得
    user_work_ids = []
    Work.joins('INNER JOIN families ON works.creator_id = families.creator_id')
        .select('works.id AS id, families.id AS family_id, works.scope_id AS scope_id, families.relation_id AS relation_id')
        .where(creator_id: select_creator_ids, families: { user_id: current_api_v1_user })
        .find_each do |work|
          user_work_ids << work.id if work.scope_id == 3 || work.scope.targets.include?(work.relation_id)
        end
    @user_works = Work.where(id: user_work_ids).order(date: :desc, updated_at: :desc).with_attached_images.includes(:creator)
  end

  private

  def work_params
    params.permit(
      :user_id,
      :date,
      :title,
      :description,
      :scope_id,
      :creator_id,
      images: []
    )
  end

  def user_check
    if current_api_v1_user.id != work_params[:user_id].to_i
      render status: 401, json: {success: false, message: 'Unauthorized'} and return
    end
  end
end
