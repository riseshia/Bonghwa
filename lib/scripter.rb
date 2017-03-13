# frozen_string_literal: true
Dir["lib/command/*.rb"].each do |lib|
  require lib.gsub("lib/", "")
end

# Scripter
module Scripter
  module_function

  def register(target_module)
    @enable_cmds ||= []
    @enable_cmds << target_module
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
    return Command::Disabled unless app.script_enabled?

    @enable_cmds.find do |cmd|
      cmd.send(:matched?, input)
    end || Command::NotFound
  end

  def send_feedback(message)
    Firewood.create(
      user_id: 0,
      user_name: "System",
      contents: message
    )
  end

  register Command::SimpleDice
  register Command::ExtendedDice
  register Command::Coin
  register Command::Rank
  register Command::MyRank
  register Command::Nickname
  register Command::AddInfo
  register Command::RemoveInfo
end
