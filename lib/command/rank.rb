# frozen_string_literal: true
module Command
  # Command::Rank
  module Rank
    module_function

    def run(params)
      script = params[:script]
      return "이 명령어에는 추가적인 인수가 필요하지 않습니다. '/등수'라고 명령해주세요." \
        unless script.args.empty?

      rs = Firewood.select("user_name, count(*) as count")
                   .where("created_at > ?", Time.zone.now - 1.month)
                   .group("user_id")
                   .order("count DESC")
                   .limit(5)
      rs.map.with_index do |row, index|
        "#{index + 1}위 - #{row.user_name}(#{row.count}개)"
      end.join(", ")
    end
  end
end
