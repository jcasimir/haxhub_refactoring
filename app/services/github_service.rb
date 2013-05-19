class GithubService

  def self.prepare(params = {})
    github_auth = {}
    if Rails.env == "production"
      github_auth[:redirect_uri] = github_callback_url
    end

    github_auth[:client_id] = '81d9e96eebf415c911d1' #this is temporary, couldn't git github.yml to send info
    github_auth[:client_secret] = "f539d89fc3d4735ed65d827db173fa778d9fdb84"
    github_auth[:ssl] = {:verify => false}
    if params[:github_token]
      github_auth[:oauth_token] = params[:github_token]
    end
    github_auth
  end

  def self.connection
    Github.new(GithubService.prepare)
  end

  def self.user_connection(user)
    Github.new(GithubService.prepare(github_token: user.token))
  end

  def self.current_user(oauth_code)
    github = connection
    github.oauth_token = github.get_token( oauth_code ).token
    # connection.oauth_token = connection.get_token( oauth_code ).token
    [github.users.get, github.oauth_token]
  end
end
