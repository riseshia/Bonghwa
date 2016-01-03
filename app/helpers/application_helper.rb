# ApplicationHelper
module ApplicationHelper
  protected

    def isAdmin?(user)
      if user.level == 999
        return true
      else
        return false
      end
    end
end
