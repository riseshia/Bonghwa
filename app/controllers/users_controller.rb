# frozen_string_literal: true
# UsersController
class UsersController < ApplicationController
  before_action :editable

  # GET /users/1
  def show
    user = User.find(params[:id])
    render_show(user)
  end

  # GET /users/1/edit
  def edit
    user = User.find(params[:id])
    render_edit(user)
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_edit(user, "User was successfully updated.")
    else
      render_edit(user)
    end
  end

  private

  def editable
    redirect_to root_url, notice: "접근 하실 수 없습니다." \
      if @user.id != params[:id].to_i && !@user.admin?
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def render_show(user)
    render :show, locals: { user: user }
  end

  def render_edit(user)
    render :edit, locals: { user: user }
  end

  def redirect_edit(user, message)
    redirect_to user, notice: message
  end
end
