require 'bundler'
require 'json'
Bundler.require

set :public_folder, File.dirname(__FILE__)

get '/' do
  erb :home, :layout => :layout
end

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
    @data = JSON.parse request.body.read
  end

  post '/webhook' do
    content_type :json

    create_issue(@data['repository'], @data['platform'], @data['name'], @data['version'], @data['requirements'])

    status 200
    body ''
  end

  def create_issue(repository, platform, name, version, requiremnts)
    return if ENV['SKIP_PRERELEASE'] && prerelease?(platform, version)
    return if satisfied_by_requirements?(requiremnts, version, platform)

    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    client.create_issue(repository, "Upgrade #{name} to version #{version}",
    "Libraries.io has found that there is a newer version of #{name} that this project depends on.

More info: https://libraries.io/#{platform.downcase}/#{name}/#{version}",
    labels: ENV['GITHUB_LABELS'])
  end

  def satisfied_by_requirements?(requiremnts, version, platform = nil)
    return false if requiremnts.nil? || requiremnts.empty?
    requiremnts.none? do |requirement|
      SemanticRange.gtr(version, requirement, false, platform)
    end
  rescue
    false
  end

  def prerelease?(platform, version)
    parsed_version = SemanticRange.parse(version) rescue nil
    return true if parsed_version && parsed_version.prerelease.length > 0
    if platform.downcase == 'rubygems'
      !!(version =~ /[a-zA-Z]/)
    else
      false
    end
  end
end
