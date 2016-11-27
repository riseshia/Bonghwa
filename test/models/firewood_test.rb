# frozen_string_literal: true
require "test_helper"

def build_firewood(params = {})
  default_params = {
    attach_id: 0, is_dm: 0, mt_root: 0,
    prev_mt: 0, user_id: 1,
    user_name: "user",
    contents: "Yeah",
    created_at: Time.zone.now
  }
  Firewood.new(default_params.merge(params))
end

def create_firewood(params = {})
  build_firewood(params).tap(&:save)
end

class FirewoodTest < ActiveSupport::TestCase
  def test_scope_mention
    expected_sql = \
      "SELECT  \"firewoods\".* FROM \"firewoods\"" \
      " WHERE (is_dm = 1 OR contents like '%@user%') ORDER BY id DESC LIMIT 5"
    assert_equal expected_sql, Firewood.mention(1, "user", 5).to_sql
  end

  def test_scope_me
    expected_sql = \
      "SELECT  \"firewoods\".* FROM \"firewoods\"" \
      " WHERE \"firewoods\".\"user_id\" = 1 ORDER BY id DESC LIMIT 5"
    assert_equal expected_sql, Firewood.me(1, 5).to_sql
  end

  def test_trace
    expected_sql = \
      "SELECT  \"firewoods\".* FROM \"firewoods\"" \
      " WHERE (is_dm = 0 OR is_dm = 1 OR user_id = 1) ORDER BY id DESC LIMIT 5"
    assert_equal expected_sql, Firewood.trace(1, 5).to_sql
  end

  def test_scope_after
    expected_sql = \
      "SELECT \"firewoods\".* FROM \"firewoods\" WHERE (id > 5)"
    assert_equal expected_sql, Firewood.after(5).to_sql
  end

  def test_scope_before
    expected_sql = \
      "SELECT \"firewoods\".* FROM \"firewoods\" WHERE (id < 5)"
    assert_equal expected_sql, Firewood.before(5).to_sql
  end

  def test_cmd_returns_true
    fw = build_firewood(contents: "/some_command params")
    assert fw.cmd?
  end

  def test_cmd_returns_false
    fw = build_firewood(contents: "normal text")
    refute fw.cmd?
  end

  def test_dm_returns_true_with_dm_text
    fw = build_firewood(contents: "!nickname text")
    assert fw.dm?
  end

  def test_dm_returns_true_with_is_dm
    fw = build_firewood(is_dm: 1, contents: "normal text")
    assert fw.dm?
  end

  def test_dm_returns_false
    fw = build_firewood(contents: "normal text")
    refute fw.dm?
  end

  def test_system_dm_returns_true
    fw = build_firewood(is_dm: 1, user_id: 0)
    assert fw.system_dm?
  end

  def test_system_dm_returns_false_with_normal_fw
    fw = build_firewood(user_id: 0)
    refute fw.system_dm?
  end

  def test_system_dm_returns_false_with_dm
    fw = build_firewood(is_dm: 1, user_id: 1)
    refute fw.system_dm?
  end

  def test_normal_returns_true
    fw = build_firewood
    assert fw.normal?
  end

  def test_normal_returns_false
    fw = build_firewood(is_dm: 1)
    refute fw.normal?
  end

  def test_visible_returns_true_with_normal_text
    fw = build_firewood(is_dm: 0)
    assert fw.visible?(100)
  end

  def test_visible_returns_true_with_dm
    fw = build_firewood(is_dm: 100)
    assert fw.visible?(100)
  end

  def test_visible_returns_true_with_mine
    fw = build_firewood(user_id: 100)
    assert fw.visible?(100)
  end

  def test_visible_returns_false
    fw = build_firewood(is_dm: 1)
    refute fw.visible?(100)
  end

  def test_to_hash_for_api
    fw = create_firewood
    expected_hash = {
      "id" => fw.id,
      "is_dm" => fw.is_dm, "mt_root" => fw.mt_root,
      "prev_mt" => fw.prev_mt, "user_id" => fw.user_id,
      "name" => fw.user_name, "contents" => fw.contents,
      "img_id" => fw.attach_id, "img_link" => fw.img_link,
      "img_adult_flg" => fw.attach&.adult_flg,
      "created_at" => fw.created_at.strftime("%D %T")
    }

    assert_equal expected_hash, fw.to_hash_for_api
  end

  def test_img_link_return_zero
    fw = build_firewood(attach_id: 0)

    assert_equal "0", fw.img_link
  end

  def test_img_link_return_img_url
    attach = Attach.new(id: 1)
    fw = build_firewood(attach: attach)

    assert_equal "/imgs/original/missing.png", fw.img_link
  end

  def test_editable_returns_true
    user_id = 1
    fw = build_firewood(user_id: user_id)
    user = User.new(id: user_id)

    assert fw.editable?(user)
  end

  def test_editable_returns_false
    fw = build_firewood(user_id: 10)
    user = User.new(id: 20)

    refute fw.editable?(user)
  end

  def test_system_dm_works
    fw = Firewood.system_dm(message: "Contents", user_id: 4)

    assert fw.persisted?
    assert_equal 0, fw.user_id
    assert_equal "System", fw.user_name
    assert_equal "Contents", fw.contents
    assert_equal 4, fw.is_dm
  end
end
