# frozen_string_literal: true
module Command
  # Command::ExtendedDice
  module ExtendedDice
    module_function

    def run(params)
      script = params[:script]
      return "이 명령어는 추가 인수를 받지 않습니다." unless script.args.empty?
      _, n, r = script.command.split(%r{\/|d}).map(&:to_i)
      if (1..50).cover?(n) && (1..20).cover?(r)
        rd = Random.new
        dices = (1..r).map { (rd.rand(n) + 1).to_s }
        "#{dices.join(', ')} 의 주사위 눈이 나왔습니다."
      else
        "2면에서 50면, 1개에서 20개의 주사위를 굴리실 수 있습니다. 예를 들어, '/6d4'는 6면체 주사위 4개를 굴립니다."
      end
    end
  end
end
