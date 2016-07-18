# frozen_string_literal: true
# UsersController
class UsersController < ApplicationController
  before_action :set_user
  before_action :editable
  before_action :duplicated_name_check, only: :update

  # GET /users/1
  def show
    @user = User.find_by_id(params[:id])
  end

  # GET /users/1/edit
  def edit
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render action: "edit"
    end
  end

  private

  def duplicated_name_check
    if params.require(:user).permit(:name) == "System"
      return redirect_to :back, notice: "그 이름은 사용하실 수 없습니다."
    end
  end

  def editable
    if @user.id != params[:id].to_i && !@user.admin?
      return redirect_to index_url, notice: "접근 하실 수 없습니다."
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
