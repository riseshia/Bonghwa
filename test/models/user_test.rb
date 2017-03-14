# frozen_string_literal: true
require "test_helper"

class UserTest < ActiveSupport::TestCase
  def redis
    RedisWrapper
  end

  validate_presence_of(:name)
  validate_presence_of(:login_id)

  def test_uniqueness_of_login_id
    user = users(:asahi)
    dup_user = User.create(login_id: user.login_id)

    assert_includes dup_user.errors.messages[:login_id],
                    "has already been taken"
  end

  def test_uniqueness_of_name
    user = users(:asahi)
    dup_user = User.create(name: user.name)

    assert_includes dup_user.errors.messages[:name],
                    "has already been taken"
  end

  def test_admin_returns_true
    assert users(:luna).admin?
  end

  def test_admin_returns_false
    refute users(:asahi).admin?
  end

  def test_unconfirmed_returns_true
    assert users(:gnunu).unconfirmed?
  end

  def test_unconfirmed_returns_false
    refute users(:asahi).unconfirmed?
  end

  def test_lvup_bang
    user = users(:gnunu)
    user.lvup!

    assert_equal 1, user.reload.level
  end

  def test_update_nickname_returns_true
    assert users(:asahi).update_nickname("Ryusei")
  end

  def test_update_nickname_returns_false
    refute users(:gnunu).update_nickname("Luna")
  end

  def test_update_nickname_update_redis_cache
    new_nickname = "Ryusei"
    user = users(:asahi)
    user.update_nickname(new_nickname)

    ts = Time.zone.now.to_i
    active_users = redis.zrangebyscore("active-users", ts - 40, ts)

    assert active_users.include?(new_nickname)
    assert_equal user.to_json, redis.get("session-#{user.id}")
  end

  def test_valid_password_returns_true_with_legacy
    user = users(:yachiyo)
    hashed_password = user.legacy_password
    old_password = "old_password"

    BCrypt::Password.stub(:new, old_password) do
      assert user.valid_password?(old_password)
      user.reload
      refute user.legacy_password
      assert user.password
    end
  end

  def test_valid_password_returns_false_with_legacy
    user = users(:yachiyo)
    hashed_password = "the other hashed string"
    wrong_password = "wrong_password"
    correct_password = "old_password"

    BCrypt::Password.stub(:new, correct_password) do
      refute user.valid_password?(wrong_password)
      user.reload
      assert user.legacy_password
      refute user.password
    end
  end

  def test_valid_password_returns_true_with_devise
    asahi = users(:asahi)
    password = "devise_password"
    asahi.tap { |obj| obj.password = "devise_password" }.save
    assert asahi.valid_password?(password)
  end

  def test_set_recent_login_before_create
    expected_time = Time.zone.now
    Time.zone.stub(:now, expected_time) do
      user = User.create(
        login_id: "login_id",
        name: "name",
        password: "password",
        level: 0
      )
      assert_equal expected_time.to_i, user.recent_login.to_i
    end
  end

  def test_update_login_info
    ts = Time.zone.now.to_i
    user = users(:asahi)
    user.update_login_info(ts)
    users = RedisWrapper.zrangebyscore("active-users", ts - 10, ts + 10)
                        .sort.map { |user| { "name" => user } }

    assert_includes users, "name" => user.name
  end

  def test_on_timeline
    ts = Time.zone.now.to_i
    user_name = "asahi"
    RedisWrapper.zadd("active-users", ts, user_name)
    [
      [ts - 10, []],
      [ts + 10, [{ "name" => user_name }]],
      [ts + 30, []]
    ].each do |to_ts, expected|
      assert_equal expected, User.on_timeline(to_ts)
    end
  end
end
