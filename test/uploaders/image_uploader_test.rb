# frozen_string_literal: true
require "test_helper"
require "carrierwave/test/matchers"

class ImageUploderTest < ActiveSupport::TestCase
  include CarrierWave::Test::Matchers

  def setup
    ImageUploader.enable_processing = true
    firewood = OpenStruct.new

    @uploader = ImageUploader.new(firewood, :image)
    File.open(test_file_path) { |f| @uploader.store!(f) }
  end

  def teardown
    ImageUploader.enable_processing = false
    @uploader.remove!
  end

  def test_uploaded_file_has_correct_content_type
    assert_equal "image/jpeg", @uploader.content_type
  end

  def test_uploaded_file_has_correct_time_format
    tz = Time.zone.now
    assert @uploader.filename.start_with?(tz.strftime("%Y%m%d"))
  end

  private

  def test_file_path
    Rails.root.join("test", "assets", "test.jpg")
  end
end
