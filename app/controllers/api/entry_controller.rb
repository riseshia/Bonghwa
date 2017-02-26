# frozen_string_literal: true
# Api::BaseController
module Api
  class EntryController < Api::BaseController
    def create
      Firewood.create!(fw_params)
      render_empty_json
    end

    def create_cmd
      firewood = Firewood.create!(fw_params)
      Scripter.execute(firewood: firewood, user: @user, app: @app)

      render_empty_json
    end

    def create_dm
      contents = fw_params[:contents]
      fw_parsed = contents.match('^!(\S+)(\s(.+))?') # parsing

      raise "잘못된 DM 명령입니다. '!상대 보내고 싶은 내용'이라는 " \
            "양식으로 작성해주세요." \
        if fw_params[:image].blank? && (fw_parsed.nil? || fw_parsed[2].nil?)

      dm_user = User.find_by(name: fw_parsed[1]) # user check
      raise "존재하지 않는 상대입니다. 정확한 닉네임으로 보내보세요." \
        if dm_user.nil?

      Firewood.create({ is_dm: dm_user.id }.merge(fw_params))
    rescue Exception => e
      Firewood.create({ is_dm: @user.id }.merge(fw_params))
      Firewood.system_dm(user_id: @user.id, message: e.message)
    ensure
      render_empty_json
    end

    def destroy
      fw = Firewood.find(params[:id])
      fw.destroy if fw.editable? @user

      render_empty_json
    end

    def now
      render_timeline(50, @user)
    end

    def mts
      render_json(
        Firewood.mts_of(params[:root_mt_id], @user.id, params[:target_id])
      )
    end

    def pulling
      render_timeline(1000, @user)
    end

    def trace
      limit = params[:count].to_i.clamp(0, 50) # Limit maximum size
      render_timeline(limit, @user)
    end

    private

    def render_timeline(limit, user)
      scope = Firewood.fetch_scope_for_type(params[:type])
      firewoods =
        Firewood.
        before(params[:before]).
        after(params[:after]).
        send(scope, @user, limit)

      user.update_login_info(Time.zone.now.to_i)
      users = recent_users
      infos = Info.all

      render_json(firewoods, users, infos)
    end

    def recent_users
      now_timestamp = Time.zone.now.to_i
      before_timestamp = now_timestamp - 40
      User.on_timeline(before_timestamp, now_timestamp)
    end

    def render_empty_json
      render json: JSON.dump("")
    end

    def render_json(firewoods, users = [], infos = [])
      render "api/entry", locals: {
        firewoods: firewoods, users: users, infos: infos
      }
    end

    def fw_params
      @ps ||= \
        params.
          require(:firewood).
          permit(:prev_mt_id, :root_mt_id, :contents, :image, :image_adult_flg).
          to_h.merge(user_id: @user.id, user_name: @user.name)
    end
  end
end
