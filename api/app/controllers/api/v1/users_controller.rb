class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!

  def show
    @user = User.find(params[:id])
  end
end
