# frozen_string_literal: true

module Command
  # Command::SimpleDice
  module SimpleDice
    module_function

    def matched?(input)
      "/주사위" == input
    end

    def run(params)
      script = params[:script]
      return "명령어는 '/주사위 {면수:생략시 6}'입니다." if script.args_size > 1

      dice_size = script.no_args? ? 6 : script.first_arg.to_i
      if (1..100).cover?(dice_size)
        rd = Random.new
        "#{rd.rand(dice_size) + 1}이(가) 나왔습니다."
      else
        "인수 지정이 잘못되었습니다. 2에서 100 사이의 자연수를 입력해주세요."
      end
    end
  end
end
