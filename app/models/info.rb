# frozen_string_literal: true
# Info
class Info < ApplicationRecord
  def to_hash_for_api
    {
      id: id,
      information: infomation
    }
  end
end
