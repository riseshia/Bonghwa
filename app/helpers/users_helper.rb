# frozen_string_literal: true
# UsersHelper
module UsersHelper
  def level_up(user)
    if user.unconfirmed?
      link_to "Level up", lvup_users_path(id: user.id)
    else
      "Done"
    end
  end
end
