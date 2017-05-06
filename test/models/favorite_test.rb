require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  def favorite
    @favorite ||= Favorite.new
  end

  def test_valid
    assert favorite.valid?
  end
end
