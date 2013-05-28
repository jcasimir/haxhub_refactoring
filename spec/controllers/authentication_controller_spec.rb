require 'spec_helper'

describe AuthenticationController do
  describe "GET #github_auth" do
    class GithubStub
      def authorize_url(arg)
        "http://example.com"
      end
    end

    it "redirects to github's authorize URL" do
      Github.stub(:new).and_return(GithubStub.new)
      expect(get :github_auth).to redirect_to("http://example.com")
    end
    
    context "when in production" do
      before(:each) do
        Rails.env.stub(:production?).and_return(true)
      end

      it "uses a redirect URI" do
        github = GithubStub.new
        Github.stub(:new).and_return(github)
        params = {
          :redirect_uri => "http://haxhub.herokuapp.com/auth/github/callback",
          :scope => "public_repo"
        }
        github.should_receive(:authorize_url).with(params).and_return("http://example.com")
        get :github_auth
      end
    end

    context "when not in production" do
      it "does not use a redirect URI" do
        github = GithubStub.new
        Github.stub(:new).and_return(github)
        params = {
          :scope => "public_repo"
        }
        github.should_receive(:authorize_url).with(params).and_return("http://example.com")
        get :github_auth
      end
    end
  end
  describe "GET #github_callback"
  describe "GET #destroy"
end
