# frozen_string_literal: true

module CommandHelper
  def build_params(command, user=nil)
    firewood = Firewood.new(contents: command)
    { script: Script.new(firewood), user: user }
  end
end

module ActiveSupport
  class TestCase
    include CommandHelper
  end
end
