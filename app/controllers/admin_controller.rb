class AdminController < ApplicationController
  skip_before_action :authorize, only: [:new_app]
  skip_before_action :app_setting, only: [:new_app]
  before_action :admin_check, except: [:new_app]

  def index
  end

  # 처음 앱을 실행했을때 초기화 작업
  def new_app
    if App.all.size == 0
      # initialize app
      @app = App.new
      @app.home_name = 'Bonghwa'
      @app.home_link = '/'
      @app.app_name = 'Bonghwa'
      @app.use_script = false
      @app.show_widget = false
      @app.widget_link = nil

      @app.save!

      # add Help to Link
      @link = Link.new
      @link.link_to = '/help'
      @link.name = 'Help'

      @link.save!

      # create admin account
      @admin = User.new
      @admin.login_id = 'admin'
      @admin.password_digest = BCrypt::Password.create('admin')
      @admin.name = '관리자'
      @admin.level = 999
      @admin.recent_login = realTime

      @admin.save!

      return redirect_to login_url, notice: '초기 설정이 완료되었습니다. admin/admin으로 로그인해주세요. 비밀번호는 곧바로 변경하시기를 권장합니다. 사용법은 Link의 Help 문서를 참조해주세요.'
    else
      return redirect_to login_url, notice: '접근할 수 없거나, 존재하지 않는 페이지입니다.'
    end
  end

  def edit
  end

  def update
    @app = App.first

    respond_to do |format|
      if @app.update_attributes(params[:app])
        $redis.set("#{$servername}:app-data", Marshal.dump(@app))
        format.html { redirect_to admin_edit_url, notice: 'app setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end
end
