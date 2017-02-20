# frozen_string_literal: true

module Warning
  # only one class method of this.
  def self.warn(msg)
    return if msg.include?("constant ::Fixnum is deprecated") ||
              msg.include?("constant ::Bignum is deprecated")
    super
  end
end
