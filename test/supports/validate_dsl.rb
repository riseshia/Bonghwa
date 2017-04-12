# frozen_string_literal: true

module ValidateDsl
  def klass
    @klass ||= const_get(to_s.gsub("Test", "").to_sym)
  end

  def validate_presence_of(key)
    define_validate_presence_truthy(key)
    define_validate_presence_falsy(key)
  end

  def define_validate_presence_truthy(key)
    define_method "test_#{key} presence validates" do
      instance = self.class.klass.new
      instance.validate
      assert instance.errors.added? key, :blank
    end
  end

  def define_validate_presence_falsy(key)
    define_method "test_#{key} presence validates passed" do
      instance = self.class.klass.new
      instance.send("#{key}=", "some_value")
      instance.validate
      refute instance.errors.added? key, :blank
    end
  end
end

module ActiveSupport
  class TestCase
    extend ValidateDsl
  end
end
