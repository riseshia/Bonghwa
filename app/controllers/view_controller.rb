# ViewController
class ViewController < ApplicationController
  def timeline
    @new_fw = Firewood.new
    @infos = Info.all_with_cache
  end
end
