require "../spec_helper"

describe Dorsum::Oauth::Authorization do
  it "formats an authorize URL" do
    redis = Redis::PooledClient.new
    config = Dorsum::Config.new(
      {"client_id" => "Cyw9VcPohk7BYAfJ"}
    )
    authorization = Dorsum::Oauth::Authorization.new(
      redis,
      config,
      "http://example.com/redirect",
      [] of String
    )
    authorization.url.should eq \
      "https://id.twitch.tv/oauth2/authorize" \
    "?client_id=Cyw9VcPohk7BYAfJ&redirect_uri=http%3A%2F%2Fexample.com%2Fredirect&response_type=code&scope=" \
    "&state=#{authorization.state}"
  end
end
