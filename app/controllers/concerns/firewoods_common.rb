# frozen_string_literal: true

# FirewoodsCommon
module FirewoodsCommon
  extend ActiveSupport::Concern

  included do
    before_action :touch_user
  end

  def touch_user
    current_user.update_login_info(Time.zone.now.to_i)
  end

  def fws_data(limit)
    scope = Firewood.fetch_scope_for_type(params[:type])
    Firewood
      .before(params[:before])
      .after(params[:after])
      .send(scope, current_user, limit)
      .map(&:serialize)
  end
end
