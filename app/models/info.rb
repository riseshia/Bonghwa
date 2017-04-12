# frozen_string_literal: true

# Info
class Info < ApplicationRecord
  def serialize
    { id: id, information: infomation }
  end
end
