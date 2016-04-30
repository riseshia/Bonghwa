# frozen_string_literal: true
# UsersHelper
module UsersHelper
  def level_up(user)
    if user.level.zero?
      link_to "Level up", lvup_users_path(id: user.id)
    else
      "done"
    end
  end
end
