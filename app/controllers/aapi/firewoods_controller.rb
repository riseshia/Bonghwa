# frozen_string_literal: true

module Aapi
  # Aapi::FirewoodsController
  class FirewoodsController < Aapi::BaseController
    before_action :touch_user

    def create
      if params["firewood"]["contents"].match("^!.+")
        create_dm
      else
        firewood = Firewood.create!(fw_params)
        if params["firewood"]["contents"].match("^/.+")
          app = App.first_with_cache
          Scripter.execute(firewood: firewood, user: current_user, app: app)
        end
      end

      render json: JSON.dump("")
    end

    def destroy
      fw = Firewood.find(params[:id])
      fw.destroy if fw.editable? current_user

      render json: JSON.dump("")
    end

    private

    def create_dm
      contents = fw_params[:contents]
      fw_parsed = contents.match('^!(\S+)(\s(.+))?') # parsing

      if fw_params[:image].blank? && (fw_parsed.nil? || fw_parsed[2].nil?)
        raise "잘못된 DM 명령입니다. '!상대 보내고 싶은 내용'이라는 " \
              "양식으로 작성해주세요."
      end

      dm_user = User.find_by(name: fw_parsed[1]) # user check
      raise "존재하지 않는 상대입니다. 정확한 닉네임으로 보내보세요." \
        if dm_user.nil?

      Firewood.create({ is_dm: dm_user.id }.merge(fw_params))
    rescue Exception => e
      Firewood.create({ is_dm: current_user.id }.merge(fw_params))
      Firewood.system_dm(user_id: current_user.id, message: e.message)
    end

    def touch_user
      current_user.update_login_info(Time.zone.now.to_i)
    end

    def fw_params
      @_fw_params ||=
        params
        .require(:firewood)
        .permit(:prev_mt_id, :root_mt_id, :contents, :image, :image_adult_flg)
        .to_h.merge(user_id: current_user.id, user_name: current_user.name)
    end
  end
end
