# frozen_string_literal: true
# ViewController
class ViewController < ApplicationController
  skip_before_action :block_unconfirmed, only: :wait

  def timeline
    new_fw = Firewood.new
    infos = Info.all
    render :timeline, locals: { new_fw: new_fw, infos: infos }
  end

  def wait
    render :wait
  end
end
