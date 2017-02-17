# frozen_string_literal: true
module ActiveSupport
  class TestCase
    def build_user(params = {})
      default_params = {
        login_id: "login_id",
        name: "name",
        password: "password",
        level: 0
      }
      User.new(default_params.merge(params))
    end

    def create_user(params = {})
      build_user(params).tap(&:save)
    end

    def build_app(params = {})
      default_params = {
        home_name: "Bonghwa",
        home_link: "/",
        app_name: "App",
        use_script: 1
      }
      App.new(default_params.merge(params))
    end

    def create_app(params = {})
      build_app(params).tap(&:save)
    end

    def build_firewood(params = {})
      default_params = {
        is_dm: 0,
        contents: "Contents",
        root_mt_id: 0,
        prev_mt_id: 0,
        image: nil
      }
      Firewood.new(default_params.merge(params))
    end

    def create_firewood(params = {})
      build_firewood(params).tap(&:save)
    end

    def build_info(params = {})
      default_params = { infomation: "Information" }
      Info.new(default_params.merge(params))
    end

    def create_info(params = {})
      build_info(params).tap(&:save)
    end
  end
end
