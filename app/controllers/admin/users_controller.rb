# frozen_string_literal: true

module Admin
  # UsersController
  class UsersController < Admin::BaseController
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
      user.lvup!
      RedisWrapper.del("session-#{user.id}")
      redirect_index("User was successfully updated.")
    end

    # PUT /users/1
    def update
      user = User.find(params[:id])
      new_password = params[:user][:password]
      if new_password != params[:user][:password_confirmation]
        render_edit(user, "password and confimation is different.")
      else
        user.update!(password: new_password)
        redirect_edit(user, "User was successfully updated.")
      end
    end

    private

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
      redirect_to edit_admin_user_path(user), notice: message
    end
  end
end
