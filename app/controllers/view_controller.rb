# frozen_string_literal: true
# ViewController
class ViewController < ApplicationController
  skip_before_action :block_unconfirmed, only: :wait
  def timeline
    @new_fw = Firewood.new
    @infos = Info.all_with_cache
  end
end
