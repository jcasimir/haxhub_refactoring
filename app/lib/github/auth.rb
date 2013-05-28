module Github
  module Auth
    def self.params
      build_params
    end

    def self.build_params
      auth_params = { :scope => "public_repo" }

      if Rails.env.production?
        auth_params[:redirect_uri] = "http://haxhub.herokuapp.com/auth/github/callback"
      end

      return auth_params
    end

    def self.setup
      params
    end
  end
end
