module UsersHelper
  def level_up(user)
    if user.level == 0
      return link_to 'Level up', lvup_users_path(id: user.id)
    else
      return 'done'
    end
  end
end
