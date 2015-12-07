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

    begin
      version = SemanticRange.valid(@request_payload['version'])
    rescue
      version = @request_payload['version']
    end

    unless ENV['SKIP_PRERELEASE'] && version.is_a?(SemanticRange::Version) && version.prerelease.present?
      create_issue(@request_payload['repository'], @request_payload['platform'], @request_payload['name'], @request_payload['version'])
    end

    status 200
    body ''
  end

  def create_issue(repository, platform, name, version)
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    client.create_issue(repository, "Upgrade #{name} to version #{version}",
    "Libraries.io has found that there is a newer version of #{name} that this project depends on.

More info: https://libraries.io/#{platform.downcase}/#{name}/#{version}",
    labels: ENV['GITHUB_LABELS'])
  end
end
