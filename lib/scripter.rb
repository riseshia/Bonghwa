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

  def execute(firewood:, app:, user:)
    script = Script.new(firewood)
    new_params = { script: script, firewood: firewood, app: app, user: user }

    command = cmd_find(script.command, app)
    send_feedback(
      command.send(:run, new_params)
    )
  end

  def cmd_find(input, app)
    return @comments["disabled"] unless app.script_enabled?

    return @comments[input] if @comments[input].present?

    command_obj = @comments.find do |cmd, _method|
      next if cmd.is_a? String
      cmd.match(input)
    end

    command_obj ? command_obj.last : @comments["not_found"]
  end

  def send_feedback(message)
    Firewood.create(
      user_id: 0,
      user_name: "System",
      contents: message
    )
  end

  register "disabled", Command::Disabled
  register "not_found", Command::NotFound
  register "/주사위", Command::SimpleDice
  register %r{\/[0-9]+d[0-9]+}, Command::ExtendedDice
  register "/코인", Command::Coin
  register "/등수", Command::Rank
  register "/내등수", Command::MyRank
  register "/닉", Command::Nickname
  register "/공지추가", Command::AddInfo
  register "/공지삭제", Command::RemoveInfo
end
