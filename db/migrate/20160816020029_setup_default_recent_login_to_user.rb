# frozen_string_literal: true
class SetupDefaultRecentLoginToUser < ActiveRecord::Migration[4.2]
  def up
    User.where(recent_login: nil).each do |user|
      user.recent_login = user.created_at
      user.save
    end
  end

  def down
  end
end
