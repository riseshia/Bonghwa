# frozen_string_literal: true
module Command
  # Command::RemoveInfo
  module RemoveInfo
    module_function

    def run(params)
      script = params[:script]
      user = params[:user]
      infos = Info.all
      number_of_info = script.args.first.try(:to_i)
      case
      when !user.admin?
        "권한이 없습니다."
      when script.arg.empty?
        "삭제할 공지의 id를 주셔야합니다."
      when script.arg.size != 1
        "인수가 너무 많습니다. 삭제할 공지의 번호만을 주세요."
      when infos.nil?, infos.all.size < number_of_info
        "삭제할 공지사항이 없습니다."
      else
        infos[number_of_info - 1].destroy
        "삭제 완료되었습니다."
      end
    end
  end
end
