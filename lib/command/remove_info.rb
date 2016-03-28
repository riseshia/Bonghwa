# frozen_string_literal: true
module Command
  # Command::RemoveInfo
  module RemoveInfo
    module_function

    def run(params)
      script = params[:script]
      user = params[:user]
      return "권한이 없습니다." unless user.admin?
      return "삭제할 공지의 id를 주셔야합니다." if script.arg.empty?
      return "인수가 너무 많습니다. 삭제할 공지의 번호만을 주세요." if script.arg.size != 1

      infos = Info.all
      number_of_info = script.args.first.to_i

      return "삭제할 공지사항이 없습니다." if infos.nil? || infos.size < number_of_info

      infos[number_of_info - 1].destroy
      "삭제 완료되었습니다."
    end
  end
end
