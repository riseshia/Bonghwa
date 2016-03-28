# frozen_string_literal: true
module Command
  # Command::Coin
  module Coin
    module_function
    
    def run(params)
      script = params[:script]
      if script.args.size == 0
        "#{rand(1..2) == 1 ? '앞면' : '뒷면'}이 나왔습니다."
      else
        "명령어는 '/코인'입니다."
      end
    end
  end
end
