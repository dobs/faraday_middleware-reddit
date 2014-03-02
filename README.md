# FaradayMiddleware::Reddit

A collection of Faraday middleware for use with the Reddit API.

## Installation

Add this line to your application's Gemfile:

    gem 'faraday_middleware-reddit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday_middleware-reddit

## Requirements

`faraday` and `faraday_middleware` are currently gemspec dependencies.

Like `faraday_middleware`, `faraday_middleware-reddit` requires a `json` library. Ruby versions prior to 1.9 will need to have one installed.

## Usage

`faraday_middleware-reddit` currently provides the following middleware:

| Middleware | Type | Description |
| --- | --- | --- |
| `:reddit_authentication` | request | Authentication based on a username, password or pre-generated cookie. |
| `:reddit_force_json` | request | Coerces reddit into returnign JSON for GET and POST requests. |
| `:reddit_modhash` | use | Automatic modhash handling. |
| `:reddit_rate_limit` | use | Rate limiting based on reddit's `x-ratelimit` headers. Accepts a `strategy` proc to override default linear strategy. |

## Examples

An example Farday client might look like:

    require 'faraday_middleware/reddit'

    conn = Faraday.new(:url => 'http://www.reddit.com', :headers => {'User-Agent' => 'faraday_middleware-reddit example (v 0.0.1)'}) do |faraday|
      faraday.request  :url_encoded
      faraday.request  :reddit_authentication, 'yourusername', 'yourpassword'
      faraday.request  :reddit_force_json

      faraday.response :logger

      # Middleware affecting both requests and responses. Better if it sits lower
      # in the stack.
      faraday.use  :reddit_rate_limit
      faraday.use  :reddit_modhash

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

This project is copyright 2014 by its contributors, licensed under [Apache License 2.0](https://github.com/dobs/faraday_middleware-reddit/blob/master/LICENSE).
