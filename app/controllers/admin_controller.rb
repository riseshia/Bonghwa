# AdminController
class AdminController < ApplicationController
  skip_before_action :authorize, only: :new_app
  skip_before_action :app_setting, only: :new_app
  before_action :admin_check, except: :new_app

  # 처음 앱을 실행했을때 초기화 작업
  def new_app
    if App.all.size == 0
      # initialize app
      App.create!(
        home_name: 'Bonghwa',
        home_link: '/',
        app_name: 'Bonghwa',
        use_script: false,
        show_widget: false,
        widget_link: nil
      )

      # add Help to Link
      Link.create!(link_to: '/help', name: 'Help')

      # create admin account
      User.create!(
        login_id: 'admin',
        password_digest: BCrypt::Password.create('admin'),
        name: '관리자',
        level: 999,
        recent_login: real_time
      )
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
      if @app.update_attributes(app_params)
        redis.set("#{servername}:app-data", Marshal.dump(@app))
        format.html { redirect_to admin_edit_url, notice: 'app setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def app_params
    params.require(:app).permit(:app_name, :home_link, :home_name, :show_widget, :use_script, :widget_link)
  end
end
