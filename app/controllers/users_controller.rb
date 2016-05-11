# frozen_string_literal: true
# UsersController
class UsersController < ApplicationController
  before_action :admin_check, only: [:index, :destroy, :lvup]
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :editable, only: [:edit, :update]
  before_action :duplicated_name_check, only: [:create, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  # GET /users/1
  def show
    @user = User.find_by_id(params[:id])
  end

  # GET /users/new
  # GET /users/new.json
  # def new
  #   @user = User.new
  # end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  # def create
  #   @user = User.new(user_params)
  #   @user.recent_login = Time.zone.now

  #   respond_to do |format|
  #     if @user.save
  #       format.html do
  #         redirect_to login_url,
  #                     notice: "가입 신청이 완료되었습니다. 관리자에게 등업을 문의해주세요."
  #       end
  #       format.json { render json: @user, status: :created, location: @user }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /users/1/lvup
  def lvup
    @user = User.find_by_id(params[:id])
    @user.level = 1

    if @user.save
      RedisWrapper.del("session-#{@user.id}")
      redirect_to users_url,
                  notice: "User was successfully updated."
    else
      render action: "edit"
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    if params[:user][:password] != params[:user][:password_confirmation]
      render action: "edit", notice: "password and confimation is different."
    elsif @user.update(password: params[:user][:password])
      redirect_to @user, notice: "User was successfully updated."
    else
      render action: "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to users_url
  end

  private

  def duplicated_name_check
    if params[:name] == "System"
      return redirect_to :back, notice: "그 이름은 사용하실 수 없습니다."
    end
  end

  def editable
    if @user.id != params[:id].to_i && @user.level != 999
      return redirect_to index_url, notice: "접근 하실 수 없습니다."
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    params.require(:user).permit(:login_id, :name,
                                 :password, :password_confirmation)
  end
end
