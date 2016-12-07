# frozen_string_literal: true
module Command
  # Command::SimpleDice
  module SimpleDice
    module_function

    def run(params)
      args = params[:script].args
      return "명령어는 '/주사위 {면수:생략시 6}'입니다." if args.size > 1

      dice_size = args.empty? ? 6 : args[0]&.to_i || 0
      if (1..100).cover?(dice_size)
        "#{rand(1..dice_size)}이(가) 나왔습니다."
      else
        "인수 지정이 잘못되었습니다. 2에서 100 사이의 자연수를 입력해주세요."
      end
    end
  end
end
