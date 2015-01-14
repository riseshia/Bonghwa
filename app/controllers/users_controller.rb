#encoding: utf-8

class UsersController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  before_filter :admin_check, only: [:index, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    return redirect_to index_url, notice: '접근 하실 수 없습니다.' unless session[:user_id].to_i == params[:id].to_i or session[:user_level].to_i == 999
    
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    return redirect_to index_url, notice: '접근 하실 수 없습니다.' unless session[:user_id].to_i == params[:id].to_i or session[:user_level].to_i == 999
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.recent_login = Time.now

    return redirect_to ('/users/new'), notice: '그 이름은 사용하실 수 없습니다.' if params[:user][:name] == "System"

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_url, notice: '가입 신청이 완료되었습니다. 관리자에게 등업을 문의해주세요.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /users/1/lvup
  def lvup
    return redirect_to index_url, notice: '접근 하실 수 없습니다.' unless session[:user_level].to_i == 999
    @user = User.find_by_id(params[:id])
    @user.level = 1

    respond_to do |format|
      if @user.update_attributes(params[:user])
        $redis.del("#{$servername}:session-#{@user.id}")
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    return redirect_to index_url, notice: '접근 하실 수 없습니다.' unless session[:user_id].to_i == params[:id].to_i or session[:user_level].to_i == 999
    @user = User.find(params[:id])

    return redirect_to ('/users/' + @user.id.to_s + '/edit'), notice: '그 이름은 사용하실 수 없습니다.' if params[:user][:name] == "System"
    return redirect_to ('/users/' + @user.id.to_s + '/edit'), notice: '공백을 사용하실 수 없습니다.' unless params[:user][:name].scan(" ").size == 0
    respond_to do |format|
      if @user.update_attributes(params[:user]) 
        session[:user_name] = @user.name
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end

