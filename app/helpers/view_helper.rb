# frozen_string_literal: true
# ViewHelper
module ViewHelper
  def unescape_tag(str)
    a = str.gsub("&lt;", "<")
    a.gsub("&gt;", ">")
  end
end
