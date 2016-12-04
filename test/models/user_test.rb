# frozen_string_literal: true
require "test_helper"

class UserTest < ActiveSupport::TestCase
  def redis
    RedisWrapper
  end

  validate_presence_of(:name)
  validate_presence_of(:login_id)

  def test_uniqueness_of_login_id
    create_user(name: "name1", login_id: "login_id")
    user = create_user(name: "name2", login_id: "login_id")
    assert_equal 1, user.errors.count
  end

  def test_uniqueness_of_name
    create_user(name: "same_name", login_id: "login_id1")
    user = create_user(name: "same_name", login_id: "login_id2")
    assert_equal 1, user.errors.count
  end

  def test_admin_returns_true
    user = build_user(level: 999)
    assert user.admin?
  end

  def test_admin_returns_false
    user = build_user(level: 1)
    refute user.admin?
  end

  def test_unconfirmed_returns_true
    user = build_user(level: 0)
    assert user.unconfirmed?
  end

  def test_unconfirmed_returns_false
    user = build_user(level: 1)
    refute user.unconfirmed?
  end

  def test_update_nickname_returns_true
    user = create_user
    assert user.update_nickname("new_nick")
  end

  def test_update_nickname_returns_false
    user = create_user(login_id: "lid1")
    create_user(login_id: "lid2", name: "new_nick")
    refute user.update_nickname("new_nick")
  end

  def test_update_nickname_update_redis_cache
    user = create_user
    redis.zrem("active-users", "new_nick")
    redis.set("session-#{user.id}", nil)

    user.update_nickname("new_nick")

    ts = Time.zone.now.to_i
    active_users = redis.zrangebyscore("active-users", ts - 40, ts)
    assert active_users.include?("new_nick")
    assert_equal user.to_json, redis.get("session-#{user.id}")
  end

  def test_valid_password_returns_true_with_legacy
    user = build_user(password: nil, legacy_password: "1234")
    user.stub(:validate_legacy_password, true, "1234") do
      assert user.valid_password?("1234")
    end
  end

  def test_valid_password_returns_false_with_legacy
    user = build_user(password: nil, legacy_password: "")
    user.stub(:validate_legacy_password, false, "") do
      refute user.valid_password?("")
    end
  end

  def test_valid_password_returns_true_with_devise
    user = build_user(password: "new_password")
    assert user.valid_password?("new_password")
  end

  def test_validate_legacy_password_returns_true
    user = create_user(legacy_password: "1234")
    BCrypt::Password.stub(:new, "hashed_string", "1234") do
      assert user.validate_legacy_password("hashed_string")
    end
  end

  def test_validate_legacy_password_returns_false
    user = create_user(legacy_password: "1234")
    BCrypt::Password.stub(:new, "hashed_string", "1234") do
      refute user.validate_legacy_password("another_string")
    end
  end

  def test_set_recent_login_before_create
    expected_time = Time.zone.now
    Time.zone.stub(:now, expected_time) do
      user = create_user
      assert_equal expected_time.to_i, user.recent_login.to_i
    end
  end
end
