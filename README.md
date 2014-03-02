# FaradayMiddleware::RedditApi

A collection of Faraday middleware for use with the Reddit API.

## Installation

Add this line to your application's Gemfile:

    gem 'faraday_middleware-reddit_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday_middleware-reddit_api

## Requirements

`faraday` and `faraday_middleware` are currently gemspec dependencies.

Like `faraday_middleware`, `faraday_middleware-reddit_api` requires a `json` library. Ruby versions prior to 1.9 will need to have one installed.

## Usage

`faraday_middleware-reddit_api` currently provides the following middleware:

| Middleware | Description |
| --- | --- |
| `:reddit_authentication` | Authentication based on a username, password or pre-generated cookie. |
| `:reddit_force_json` | Coerces reddit into returnign JSON for GET and POST requests. |
| `:reddit_modhash` | Automatic modhash handling. |
| `:reddit_rate_limit` | Rate limiting based on reddit's `x-ratelimit` headers. Accepts a `strategy` proc to override default linear strategy. |

## Examples

An example Farday client might look like:

    require 'faraday_middleware/reddit_api'

    conn = Faraday.new(:url => 'http://www.reddit.com', :headers => {'User-Agent' => 'faraday_middleware-reddit_api example (v 0.0.1)'}) do |faraday|
      faraday.request  :url_encoded
      faraday.request  :reddit_authentication, 'yourusername', 'yourpassword'
      faraday.request  :reddit_force_json
      faraday.request  :reddit_rate_limit
      faraday.request  :reddit_modhash
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Contributors
------------

  * Maintainer: [Daniel O'Brien](http://github.com/dobs)

This project is copyright 2014 by its contributors, licensed under [Apache License 2.0](https://github.com/dobs/faraday_middleware-reddit_api/blob/master/LICENSE).
