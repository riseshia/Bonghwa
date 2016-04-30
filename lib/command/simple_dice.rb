# frozen_string_literal: true
module Command
  # Command::SimpleDice
  module SimpleDice
    module_function

    def run(params)
      script = params[:script]
      args = script.args
      return "명령어는 '/주사위 {면수:생략시 6}'입니다." if args.size > 1
      return "#{rand(1..6)}이(가) 나왔습니다." if args.empty?

      dice_size = args[0].to_i
      if dice_size > 1 && dice_size < 101
        "#{rand(1..dice_size)}이(가) 나왔습니다."
      else
        "인수 지정이 잘못되었습니다. 2에서 100 사이의 자연수를 입력해주세요."
      end
    end
  end
end
