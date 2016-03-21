# frozen_string_literal: true
require "rails_helper"

RSpec.describe App, type: :model do
  describe "Active Record Validations" do
    it { should validate_presence_of(:app_name) }
  end
end
