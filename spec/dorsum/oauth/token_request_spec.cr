require "../spec_helper"
require "json"

describe Dorsum::Oauth::TokenRequest do
  it "performs a token request using a code" do
    WebMock.stub(:post, %r{\Ahttps://id.twitch.tv/oauth2/token}).to_return(
      status: 200,
      body: {
        "access_token":  "sGucD4gMSt4JK5xD",
        "expires_in":    1800,
        "refresh_token": "yAzUzVvewPngWocE",
        "scope":         [] of String,
        "token_type":    "bearer",
      }.to_json
    )

    redis = Redis::PooledClient.new
    config = Dorsum::Config.new(
      {"client_id" => "kw6tzwPHM9wTxvFx", "client_secret" => "aF5ucchov1hoG5Sk"}
    )
    redirect_uri = "http://example.com/redirect"
    authorization = Dorsum::Oauth::Authorization.new(redis, config, redirect_uri, [] of String)
    code = Dorsum::Oauth::Code.new(
      redis, config,
      HTTP::Params.parse("code=mq2m8z8skrzvnnmtdprjmh0r2gd7lq&scope=&state=#{authorization.state}")
    )
    token_request = Dorsum::Oauth::TokenRequest.new(redis, config, redirect_uri, code)
    token_request.perform.should eq true
    response = token_request.response.as(HTTP::Client::Response)
    token = Dorsum::Oauth::Token.parse(response.body)
    token.access_token.should eq "sGucD4gMSt4JK5xD"
    token.expires_in.should eq 1800
    token.refresh_token.should eq "yAzUzVvewPngWocE"
    token.scope.should eq [] of String
    token.token_type.should eq "bearer"
  end
end
