# frozen_string_literal: true

# ViewController
class ViewController < ApplicationController
  skip_before_action :block_unconfirmed

  def wait
    render :wait
  end
end
