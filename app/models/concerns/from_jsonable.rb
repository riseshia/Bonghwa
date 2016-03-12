require 'active_support/concern'

# FromJsonable
module FromJsonable
  extend ActiveSupport::Concern

  class_methods do
    def from_json(json)
      find(json['id'])
    end
  end

end