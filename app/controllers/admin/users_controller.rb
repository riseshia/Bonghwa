# frozen_string_literal: true

module Admin
  # UsersController
  class UsersController < Admin::BaseController
    before_action :duplicated_name_check, only: [:update]

    # GET /users
    def index
      users = User.paginate(page: params[:page], per_page: 10)
      render_index(users)
    end

    # GET /users/1/edit
    def edit
      user = User.find(params[:id])
      render_edit(user)
    end

    # PUT /users/1/lvup
    def lvup
      user = User.find(params[:id])
      user.lvup if user.unconfirmed?

      if user.save
        RedisWrapper.del("session-#{user.id}")
        redirect_index("User was successfully updated.")
      else
        render_edit(user)
      end
    end

    # PUT /users/1
    def update
      user = User.find(params[:id])
      if params[:user][:password] != params[:user][:password_confirmation]
        render_edit(user, "password and confimation is different.")
      elsif user.update(password: params[:user][:password])
        redirect_edit(user, "User was successfully updated.")
      else
        render_edit(user)
      end
    end

    private

    def duplicated_name_check
      redirect_to :back, notice: "그 이름은 사용하실 수 없습니다." \
        if params[:name] == "System"
    end

    def render_index(users)
      render :index, locals: { users: users }
    end

    def redirect_index(message)
      redirect_to admin_users_path, notice: message
    end

    def render_edit(user, message = nil)
      render :edit, locals: { user: user }, notice: message
    end

    def redirect_edit(user, message)
      redirect_to user, notice: message
    end

    # Never trust parameters from the scary internet,
    # only allow the white list through.
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
