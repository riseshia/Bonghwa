# frozen_string_literal: true

module Command
  # Command::Nickname
  module Nickname
    module_function

    def matched?(input)
      "/닉" == input
    end

    def run(params)
      script = params[:script]
      user = User.find(params[:user].id)
      new_nickname = script.args.first
      old_user_name = user.name

      if script.args.size != 1
        "이 명령어에는 하나의 인수가 필요합니다. '/닉 [변경할 닉네임]'라고 명령해주세요. \
               변경할 닉네임에는 공백 허용되지 않습니다."
      elsif new_nickname == user.name
        "변경하실 닉네임이 같습니다. 다른 닉네임으로 시도해 주세요."
      elsif User.find_by(name: new_nickname) || new_nickname == "System"
        "해당하는 닉네임은 이미 존재합니다."
      else
        user.update_nickname(new_nickname)
        "#{old_user_name}님의 닉네임이 #{user.name}로 변경되었습니다."
      end
    end
  end
end
