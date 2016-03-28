# frozen_string_literal: true
# Scripter
module Scripter
  COMMANDS = {
    "/주사위" => :simple_dice,
    "/코인" => :coin,
    "/등수" => :rank,
    "/내등수" => :my_rank,
    "/닉" => :nickname,
    "/공지추가" => :add_info,
    "/공지삭제" => :remove_info,
    /\/[0-9]+d[0-9]+/ => :extended_dice
  }.freeze

  module_function

  def execute(params)
    script = Script.new(params[:firewood])
    new_params = { script: script }.merge(params)
    command = if params[:firewood].app.use_script == 1
                cmd_find(script.command)
              else
                :disabled_cmd
              end

    send_feedback(
      send(command, new_params)
    )
  end

  def cmd_find(input)
    return COMMANDS[input] if COMMANDS[input].present?

    command_obj = COMMANDS.find do |cmd, _method|
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

  def extended_dice(params)
    script = params[:script]
    return "이 명령어는 추가 인수를 받지 않습니다." if script.args.size != 0
    _, n, r = script.command.split(/\/|d/).map(&:to_i)
    if (1..50).cover?(n) && (1..20).cover?(r)
      dices = (1..r).map { rand(1..n).to_s }
      "#{dices.join(', ')} 의 주사위 눈이 나왔습니다."
    else
      "2면에서 50면, 1개에서 20개의 주사위를 굴리실 수 있습니다. 예를 들어, '/6d4'는 6면체 주사위 4개를 굴립니다."
    end
  end

  def simple_dice(params)
    script = params[:script]
    args = script.args
    return "명령어는 '/주사위 {면수:생략시 6}'입니다." if args.size > 1
    return "#{rand(1..6)}이(가) 나왔습니다." if args.size == 0

    dice_size = args[0].to_i
    if dice_size > 1 && dice_size < 101
      "#{rand(1..dice_size)}이(가) 나왔습니다."
    else
      "인수 지정이 잘못되었습니다. 2에서 100 사이의 자연수를 입력해주세요."
    end
  end

  def coin(params)
    script = params[:script]
    if script.args.size == 0
      "#{rand(1..2) == 1 ? '앞면' : '뒷면'}이 나왔습니다."
    else
      "명령어는 '/코인'입니다."
    end
  end

  def rank(params)
    script = params[:script]
    return "이 명령어에는 추가적인 인수가 필요하지 않습니다. '/등수'라고 명령해주세요." if script.args.size != 0

    rs = Firewood.select("user_name, count(*) as count")
                 .where("created_at > ?", Time.zone.now - 1.month)
                 .group("user_id")
                 .order("count DESC")
                 .limit(5)
    rs.map.with_index do |row, index|
      "#{index + 1}위 - #{row.user_name}(#{row.count}개)"
    end.join(", ")
  end

  def my_rank(params)
    script = params[:script]
    user = params[:user]
    return "이 명령어에는 추가적인 인수가 필요하지 않습니다. '/내등수'라고 명령해주세요." if script.args.size != 0

    rs = Firewood.select("user_id, count(*) as count")
                 .where("created_at > ?", Time.zone.now - 1.month)
                 .group("user_id")
                 .order("count DESC, user_id ASC")

    idx = rs.map(&:user_id).index(user.id)
    "#{user.name}님이 던지신 장작은 #{rs[idx].count}개로, 현재 #{idx + 1}등 입니다."
  end

  def nickname(params)
    script = params[:script]
    user = params[:user]
    new_nickname = script.args.first
    old_user_name = user.name

    return "이 명령어에는 하나의 인수가 필요합니다. '/닉 [변경할 닉네임]'라고 명령해주세요. \
             변경할 닉네임에는 공백 허용되지 않습니다." if script.args.size != 1
    return "변경하실 닉네임이 같습니다. 다른 닉네임으로 시도해 주세요." if new_nickname == user.name
    return "해당하는 닉네임은 이미 존재합니다." \
      if User.find_by_name(new_nickname) || new_nickname == "System"

    if user.update_nickname(new_nickname)
      "#{old_user_name}님의 닉네임이 #{user.name}로 변경되었습니다."
    else
      "닉네임을 #{new_nickname}로 변경할 수 없습니다."
    end
  end

  def add_info(params)
    script = params[:script]
    user = params[:user]
    return "권한이 없습니다." unless user.admin?
    return "내용을 입력해주세요." if script.arg.empty?
    Info.create!(infomation: script.arg)
    "공지가 등록되었습니다."
  end

  def remove_info(params)
    script = params[:script]
    user = params[:user]
    return "권한이 없습니다." unless user.admin?
    return "삭제할 공지의 id를 주셔야합니다." if script.arg.empty?
    return "인수가 너무 많습니다. 삭제할 공지의 번호만을 주세요." if script.arg.size != 1

    infos = Info.all
    number_of_info = script.args.first.to_i

    return "삭제할 공지사항이 없습니다." if infos.nil? || infos.size < number_of_info

    infos[number_of_info - 1].destroy
    "삭제 완료되었습니다."
  end

  def not_found(params)
    script = params[:script]
    "명령어 '#{script.command}'를 찾을 수 없습니다."
  end

  def disabled_cmd(_params)
    "명령 기능이 비활성화되어 있습니다. 관리자에게 문의하세요."
  end
end
