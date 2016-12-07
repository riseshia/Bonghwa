# frozen_string_literal: true

module Command
  # Command::NotFound
  module NotFound
    module_function

    def run(params)
      "명령어 '#{params[:script].command}'를 찾을 수 없습니다."
    end
  end
end
