# frozen_string_literal: true

module Command
  # Command::Rank
  module Rank
    module_function

    def matched?(input)
      "/등수" == input
    end

    # rubocop:disable Metrics/MethodLength
    def run(params)
      script = params[:script]
      if script.no_args?
        rs = Firewood.select("user_name, count(id) as count")
                     .where("created_at > ?", Time.zone.now - 1.month)
                     .group(:user_name)
                     .order("count DESC")
                     .limit(5)
        rs.map.with_index do |row, index|
          "#{index + 1}위 - #{row.user_name}(#{row.count}개)"
        end.join(", ")
      else
        "이 명령어는 추가 인수를 받지 않습니다. '/등수'라고 명령해주세요."
      end
    end
  end
end
