# frozen_string_literal: true

module ActiveSupport
  class TestCase
    def say(user, text)
      Firewood.create(user: user, user_name: user.name, contents: text)
    end

    def public_system(text)
      Firewood.create(user_id: 0, user_name: "Server", contents: text)
    end

    def dm_system(text, user)
      Firewood.create(
        user_id: 0, user_name: "Server", is_dm: user.id, contents: text
      )
    end

    def mention(from_user, to_fw, text)
      root_mt_id = to_fw.root_mt_id.zero? ? to_fw.id : to_fw.root_mt_id
      prefix = to_fw.is_dm.zero? ? "@" : "!"
      is_dm = to_fw.is_dm.zero? ? 0 : to_fw.user_id

      Firewood.create(
        user: from_user, user_name: from_user.name,
        contents: "#{prefix}#{to_fw.user_name} #{text}",
        prev_mt_id: to_fw.id, root_mt_id: root_mt_id, is_dm: is_dm
      )
    end

    def dm(from_user, to_user, text)
      Firewood.create(
        user: from_user, dm_user: to_user, contents: "!#{to_user.name} #{text}"
      )
    end
  end
end
