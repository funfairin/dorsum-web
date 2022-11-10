require "../spec_helper"

describe Dorsum::Oauth::Code do
  it "verifies a state from an authorization" do
    redis = Redis::PooledClient.new
    config = Dorsum::Config.new(
      {"client_id" => "CRNHjvoCjdZYcEbV"}
    )
    authorization = Dorsum::Oauth::Authorization.new(redis, config, "http://example.com/redirect", [] of String)
    code = Dorsum::Oauth::Code.new(redis, config, HTTP::Params.parse("state=#{authorization.state}"))
    code.verified?.should eq true
  end

  it "does not verify an unknown state" do
    redis = Redis::PooledClient.new
    config = Dorsum::Config.new(
      {"client_id" => "HvpjxaygPVNKXLuj"}
    )
    code = Dorsum::Oauth::Code.new(redis, config, HTTP::Params.parse("state=unknown"))
    code.verified?.should eq false
  end
end
