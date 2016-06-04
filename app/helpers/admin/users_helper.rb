# frozen_string_literal: true
module Admin
  # UsersHelper
  module UsersHelper
    def level_up(user)
      if user.unconfirmed?
        link_to "Level up", lvup_admin_user_path(id: user.id), method: :put
      else
        "Done"
      end
    end
  end
end
