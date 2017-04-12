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
    new_password = params[:user][:password]
    if new_password != params[:user][:password_confirmation]
      render_edit(user, "password and confirmation is different.")
    else
      user.update!(password: new_password)
      redirect_edit(user, "User was successfully updated.")
    end
  end

  private

  def editable
    redirect_to root_path, notice: "접근 하실 수 없습니다." \
      if @user.id != params[:id].to_i
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def render_show(user)
    render :show, locals: { user: user }
  end

  def render_edit(user, message = nil)
    render :edit, locals: { user: user }, notice: message
  end

  def redirect_edit(user, message)
    redirect_to edit_user_path(user), notice: message
  end
end
