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

    unless ENV['SKIP_PRERELEASE'] && prerelease?(@request_payload['platform'], @request_payload['version'])
      create_issue(@request_payload['repository'], @request_payload['platform'], @request_payload['name'], @request_payload['version'])
    end

    status 200
    body ''
  end

  def prerelease?(platform, version)
    begin
      version = SemanticRange.valid(version)
      version.prerelease.present?
    rescue
      if platform.downcase == 'rubygems'
        !!(version =~ /[a-zA-Z]/)
      else
        false
      end
    end
  end

  def create_issue(repository, platform, name, version)
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    client.create_issue(repository, "Upgrade #{name} to version #{version}",
    "Libraries.io has found that there is a newer version of #{name} that this project depends on.

More info: https://libraries.io/#{platform.downcase}/#{name}/#{version}",
    labels: ENV['GITHUB_LABELS'])
  end
end
