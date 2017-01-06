# frozen_string_literal: true
require "test_helper"

class FirewoodTest < ActiveSupport::TestCase
  def test_scope_mention
    create_firewood(is_dm: 1)
    create_firewood(contents: "@user test")

    assert_equal 2, Firewood.mention(1, "user", 5).count
  end

  def test_scope_me
    create_firewood(user_id: 1)
    create_firewood(user_id: 1, contents: "@user test")

    assert_equal 2, Firewood.me(1, 5).count
    assert_equal 1, Firewood.me(1, 1).count
  end

  def test_trace
    create_firewood(user_id: 10)
    create_firewood(user_id: 10)
    create_firewood(is_dm: 2)

    assert_equal 2, Firewood.trace(10, 5).count
    assert_equal 1, Firewood.trace(10, 1).count
  end

  def test_scope_after
    fw = create_firewood

    assert_equal 0, Firewood.after(fw.id).count
    assert_equal 1, Firewood.after(fw.id - 1).count
  end

  def test_scope_before
    fw = create_firewood

    assert_equal 0, Firewood.before(fw.id).count
    assert_equal 1, Firewood.before(fw.id + 1).count
  end

  def test_mts_of_returns_correct_normal_fw
    root_fw = create_firewood
    target = create_firewood(root_mt_id: root_fw.id)
    create_firewood(root_mt_id: root_fw.id)
    assert_equal 1, Firewood.mts_of(root_fw.id, target.user_id, target.id).count
  end

  def test_mts_of_returns_correct_dm
    root_fw = create_firewood(user_id: 10)
    from_you = create_firewood(is_dm: 10, user_id: 3,
                               root_mt_id: root_fw.id, prev_mt_id: root_fw.id)
    from_me = create_firewood(is_dm: 3, user_id: 10,
                              root_mt_id: root_fw.id, prev_mt_id: from_you.id)
    target = create_firewood(is_dm: 10, user_id: 3,
                             root_mt_id: root_fw.id, prev_mt_id: from_me.id)
    assert_equal 3, Firewood.mts_of(root_fw.id, target.user_id, target.id).count
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

  def test_formatted_created_at
    dt = Time.zone.now
    fw = build_firewood(created_at: dt)

    assert dt.strftime("%y/%m/%d %T"), fw.formatted_created_at
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
