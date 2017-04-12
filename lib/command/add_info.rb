# frozen_string_literal: true

module Command
  # Command::AddInfo
  module AddInfo
    module_function

    def matched?(input)
      input == "/공지추가"
    end

    def run(params)
      script = params[:script]
      user = params[:user]
      return "권한이 없습니다." unless user.admin?
      return "내용을 입력해주세요." if script.arg.empty?
      Info.create!(infomation: script.arg)
      "공지가 등록되었습니다."
    end
  end
end
