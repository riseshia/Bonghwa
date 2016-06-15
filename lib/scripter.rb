# frozen_string_literal: true
Dir["lib/command/*.rb"].each do |lib|
  require lib.gsub("lib/", "")
end

# Scripter
module Scripter
  module_function

  def register(command, target_module)
    @comments ||= {}
    @comments[command] = target_module
  end

  def execute(params)
    script = Script.new(params[:firewood])
    new_params = { script: script }.merge(params)
    command = if params[:firewood].app.use_script == 1
                cmd_find(script.command)
              else
                :disabled_cmd
              end

    send_feedback(
      command.send(:run, new_params)
    )
  end

  def cmd_find(input)
    return @comments[input] if @comments[input].present?

    command_obj = @comments.find do |cmd, _method|
      next if cmd.is_a? String
      cmd.match(input)
    end

    command_obj ? command_obj.last : :not_found
  end

  def send_feedback(message)
    Firewood.create(
      user_id: 0,
      user_name: "System",
      contents: message
    )
  end

  def not_found(params)
    script = params[:script]
    "명령어 '#{script.command}'를 찾을 수 없습니다."
  end

  def disabled_cmd(_params)
    "명령 기능이 비활성화되어 있습니다. 관리자에게 문의하세요."
  end

  register "/주사위", Command::SimpleDice
  register %r{\/[0-9]+d[0-9]+}, Command::ExtendedDice
  register "/코인", Command::Coin
  register "/등수", Command::Rank
  register "/내등수", Command::MyRank
  register "/닉", Command::Nickname
  register "/공지추가", Command::AddInfo
  register "/공지삭제", Command::RemoveInfo
end
