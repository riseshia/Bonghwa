# frozen_string_literal: true
module Command
  # Command::Coin
  module Coin
    module_function

    def matched?(input)
      input == "/코인"
    end

    def run(params)
      script = params[:script]
      if script.args.empty?
        "#{rand(1..2) == 1 ? '앞면' : '뒷면'}이 나왔습니다."
      else
        "'/코인'은 인수를 받지 않습니다."
      end
    end
  end
end
