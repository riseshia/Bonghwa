# frozen_string_literal: true
module Command
  # Command::MyRank
  module MyRank
    module_function

    def run(params)
      script = params[:script]
      user = params[:user]
      return "이 명령어에는 추가적인 인수가 필요하지 않습니다. '/내등수'라고 명령해주세요." if script.args.size != 0

      rs = Firewood.select("user_id, count(*) as count")
                   .where("created_at > ?", Time.zone.now - 1.month)
                   .group("user_id")
                   .order("count DESC, user_id ASC")

      idx = rs.map(&:user_id).index(user.id)
      "#{user.name}님이 던지신 장작은 #{rs[idx].count}개로, 현재 #{idx + 1}등 입니다."
    end
  end
end
