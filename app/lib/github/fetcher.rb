module Github
  class Fetcher
    attr_reader :payload, :repo_source

    def initialize(input_payload, input_repo_source = Repo)
      @payload = input_payload
      @repo_source = input_repo_source
    end

    def self.fetch(payload)
      self.new( payload ).fetch
    end

    def fetch
      Resque.enqueue(FetchGitActions, user.id, repo.id)
    end

    def user
      login = payload["commits"][0]["committer"]["username"] || payload["commits"][0]["author"]["username"]
      User.where(login: login).first
    end

    def repo
      repo_source.find_by_name_and_owner( payload['repository']['name'],
                                          payload['repository']['owner']['name'] )
    end
  end
end
