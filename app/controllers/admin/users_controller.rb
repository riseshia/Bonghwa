# frozen_string_literal: true

module Admin
  # UsersController
  class UsersController < Admin::BaseController
    before_action :duplicated_name_check, only: [:update]

    # GET /users
    def index
      users = User.paginate(page: params[:page], per_page: 10)
      render :index, locals: { users: users }
    end

    # GET /users/1/edit
    def edit
      user = User.find(params[:id])
      render :edit, locals: { user: user }
    end

    # PUT /users/1/lvup
    def lvup
      user = User.find(params[:id])
      user.level = 1 if user.unconfirmed?

      if user.save
        RedisWrapper.del("session-#{user.id}")
        redirect_to admin_users_url,
                    notice: "User was successfully updated."
      else
        render :edit, locals: { user: user }
      end
    end

    # PUT /users/1
    def update
      @user = User.find(params[:id])
      if params[:user][:password] != params[:user][:password_confirmation]
        render action: "edit", notice: "password and confimation is different."
      elsif @user.update(password: params[:user][:password])
        redirect_to @user, notice: "User was successfully updated."
      else
        render action: "edit"
      end
    end

    private

    def duplicated_name_check
      redirect_to :back, notice: "그 이름은 사용하실 수 없습니다." \
        if params[:name] == "System"
    end

    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
