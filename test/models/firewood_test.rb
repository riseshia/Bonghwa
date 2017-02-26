# frozen_string_literal: true
require "test_helper"

class FirewoodTest < ActiveSupport::TestCase
  def test_scope_mention_with_public_mention
    luna = users(:luna)
    asahi = users(:asahi)
    fw = firewoods(:good_morning_from_luna)

    assert_difference "Firewood.mention(luna, 5).count" do
      mention asahi, fw, "おはようございます。"
    end
    assert_equal 1, Firewood.mention(luna, 1).count
  end

  def test_scope_mention_with_dm
    luna = users(:luna)
    asahi = users(:asahi)

    assert_difference "Firewood.mention(luna, 5).count" do
      dm asahi, luna, "ルナ様への初メールです！"
    end
    assert_equal 1, Firewood.mention(luna, 1).count
  end

  def test_scope_me
    asahi = users(:asahi)

    assert_difference "Firewood.me(asahi, 10).count" do
      say asahi, "皆さん、おはようございます！"
    end
    assert_equal 1, Firewood.me(asahi, 1).count
  end

  def test_trace
    asahi = users(:asahi)

    assert_difference "Firewood.trace(asahi, 10).count" do
      say asahi, "皆さん、おはようございます！"
    end
    assert_equal 1, Firewood.trace(asahi, 1).count
  end

  def test_scope_after
    asahi = users(:asahi)

    assert_difference "Firewood.after(0).count" do
      say asahi, "皆さん、おはようございます！"
    end
  end

  def test_scope_after_with_no_param
    refute Firewood.after.to_sql.include? "WHERE"
  end

  def test_scope_before
    asahi = users(:asahi)
    second_last = say asahi, "皆さん、おはようございます！"

    assert_difference "Firewood.before(second_last.id + 100).count" do
      say asahi, "朝食の用意ができております。"
    end
  end

  def test_scope_before_with_no_param
    refute Firewood.before.to_sql.include? "WHERE"
  end

  def test_mts_of_returns_correct_normal_fw
    asahi = users(:asahi)
    luna = users(:luna)
    fw = firewoods(:good_morning_from_luna)
    second_last = mention asahi, fw, "朝食の用意ができております。"
    last = mention luna, second_last, "わかった。すぐ行く。"

    be_one = Firewood.mts_of(second_last.root_mt_id, luna.id, second_last.id).count
    assert_equal 1, be_one
    be_two = Firewood.mts_of(last.root_mt_id, asahi.id, last.id).count
    assert_equal 2, be_two
  end

  def test_mts_of_returns_correct_dm
    minato = users(:minato)
    gnunu = users(:gnunu)
    fw = firewoods(:good_morning_from_gnunu)

    second_last = mention minato, fw, "おはよう、りそな。"
    last = mention gnunu, second_last, "今日、そっちに伺います。"

    be_one =
      Firewood.mts_of(second_last.root_mt_id, gnunu.id, second_last.id).count
    assert_equal 1, be_one
    be_two = Firewood.mts_of(last.root_mt_id, gnunu.id, last.id).count
    assert_equal 2, be_two
  end

  def test_system_dm_returns_true
    asahi = users(:asahi)
    fw = dm_system("おはようございます", asahi)
    assert fw.system_dm?
  end

  def test_system_dm_returns_false_with_normal_fw
    fw = public_system("おはようございます")
    refute fw.system_dm?
  end

  def test_system_dm_returns_false_with_dm
    fws = firewoods(:good_morning_from_luna, :good_morning_from_gnunu)
    fws.each { |fw| refute fw.system_dm? }
  end

  def test_cmd_returns_true
    luna = users(:luna)
    fw = say luna, "/coffee"
    assert fw.cmd?
  end

  def test_cmd_returns_false
    fws = firewoods(:good_morning_from_luna, :good_morning_from_gnunu)
    fws.each { |fw| refute fw.cmd? }
  end

  def test_dm_returns_true_with_dm_text
    assert firewoods(:good_morning_from_gnunu).dm?
  end

  def test_dm_returns_false
    refute firewoods(:good_morning_from_luna).dm?
  end

  def test_normal_returns_true
    assert firewoods(:good_morning_from_luna).normal?
  end

  def test_normal_returns_false
    refute firewoods(:good_morning_from_gnunu).normal?
  end

  def test_visible_returns_true_with_normal_text
    fw = firewoods(:good_morning_from_luna)
    minato = users(:minato)
    assert fw.visible?(minato.id)
  end

  def test_visible_returns_true_with_dm
    fw = firewoods(:good_morning_from_gnunu)
    minato = users(:minato)
    assert fw.visible?(minato.id)
  end

  def test_visible_returns_true_with_mine
    fw = firewoods(:good_morning_from_gnunu)
    gnunu = users(:gnunu)
    assert fw.visible?(gnunu.id)
  end

  def test_visible_returns_false
    fw = firewoods(:good_morning_from_gnunu)
    asahi = users(:asahi)
    refute fw.visible?(asahi.id)
  end

  def test_image_url_return_nil
    assert_nil firewoods(:good_morning_from_luna).image_url
  end

  def test_image_url_return_correct_url
    fw = Firewood.new
    expected = "image_url"

    fw.stub(:image, OpenStruct.new(url: expected)) do
      assert_equal expected, fw.image_url
    end
  end

  def test_editable_returns_true
    luna = users(:luna)
    fw = firewoods(:good_morning_from_luna)

    assert fw.editable?(luna)
  end

  def test_editable_returns_false
    gnunu = users(:gnunu)
    fw = firewoods(:good_morning_from_luna)

    refute fw.editable?(gnunu)
  end

  def test_formatted_created_at
    fw = firewoods(:good_morning_from_luna)
    dt = fw.created_at

    assert_equal dt.strftime("%y/%m/%d %T"), fw.formatted_created_at
  end

  def test_system_dm_works
    luna = users(:luna)
    fw = Firewood.system_dm(message: "Contents", user_id: luna.id)

    assert fw.persisted?
    assert_equal 0, fw.user_id
    assert_equal "System", fw.user_name
    assert_equal "Contents", fw.contents
    assert_equal luna.id, fw.is_dm
  end
end
