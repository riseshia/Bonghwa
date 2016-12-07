# frozen_string_literal: true

module Command
  # Command::Disabled
  module Disabled
    module_function

    def run(_params)
      "명령 기능이 비활성화되어 있습니다. 관리자에게 문의하세요."
    end
  end
end
