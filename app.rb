require 'bundler'
require 'json'
Bundler.require

class Lib2Issue < Sinatra::Base
  use Rack::Deflater

  configure do
    set :logging, true
    set :dump_errors, false
    set :raise_errors, true
    set :show_exceptions, false
  end

  before do
    request.body.rewind
    @request_payload = JSON.parse request.body.read
  end

  post '/webhook' do
    content_type :json
    puts @request_payload.inspect
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    client.create_issue(@request_payload['repository'], "Version #{@request_payload['version']} of #{@request_payload['name']} has been released")
    status 200
    body ''
  end
end
