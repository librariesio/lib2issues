# [Lib2Issues](https://libraries.io/github/librariesio/lib2issues)

Sinatra app for creating GitHub issues whenever a new version of a dependency is discovered by [Libraries.io](https://libraries.io) using the repository web hook feature.

## Usage

The easiest option is to deploy to heroku with the deploy button below:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Before you deploy the heroku app, create a Personal Access Token under your GitHub account Settings -> Developer Settings

Add that token to the `GITHUB_TOKEN` field on heroku

Once deployed on heroku, visit https://libraries.io and go the the web hooks section of the repository you would like use Lib2Issues on

Then add the url of your deployed heroku app to the web hooks section for your repo on and add `/webhook` at the end of the url, i.e. `https://mylib2issues.herokuapp.com/webhook`

<hr>

Or to run it somewhere else, clone it from github:

   git clone https://github.com/librariesio/lib2issues.git

Install dependencies:

    bundle install

Setup config environment variables:

    GITHUB_TOKEN=mygithubapitoken
    GITHUB_LABELS=help wanted,enhancement

Start the app:

    rackup

Add the url of your app to web hooks section for your repo on https://libraries.io

## Development

Source hosted at [GitHub](https://github.com/librariesio/lib2issues).
Report issues/feature requests on [GitHub Issues](https://github.com/librariesio/lib2issues/issues). Follow us on Twitter [@librariesio](https://twitter.com/librariesio). We also hangout on [Gitter](https://gitter.im/librariesio/support).

### Getting Started

New to Ruby? No worries! You can follow these instructions to install a local server, or you can use the included Vagrant setup.

#### Installing a Local Server

First things first, you'll need to install Ruby 2.5.0. I recommend using the excellent [rbenv](https://github.com/rbenv/rbenv),
and [ruby-build](https://github.com/rbenv/ruby-build)

```bash
rbenv install 2.5.0
rbenv global 2.5.0
```

### Note on Patches/Pull Requests

 * Fork the project.
 * Make your feature addition or bug fix.
 * Add tests for it. This is important so I don't break it in a
   future version unintentionally.
 * Add documentation if necessary.
 * Commit, do not change procfile, version, or history.
 * Send a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2018 Andrew Nesbitt. See [LICENSE](https://github.com/librariesio/lib2issues/blob/master/LICENSE) for details.
