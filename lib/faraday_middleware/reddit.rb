# encoding: utf-8

require 'faraday'
require 'faraday_middleware/reddit/error'
require 'faraday_middleware/reddit/helpers/modhash'

module FaradayMiddleware
  module Reddit
    autoload :Authentication, 'faraday_middleware/reddit/request/authentication'
    autoload :ForceJson,      'faraday_middleware/reddit/use/force_json'
    autoload :Modhash,        'faraday_middleware/reddit/use/modhash'
    autoload :RaiseError,     'faraday_middleware/reddit/response/raise_error'
    autoload :RateLimit,      'faraday_middleware/reddit/use/rate_limit'

    if Faraday::Middleware.respond_to? :register_middleware
      Faraday::Request.register_middleware \
        reddit_authentication: -> { Authentication }
      Faraday::Response.register_middleware \
        reddit_raise_error: -> { RaiseError }
      Faraday::Middleware.register_middleware \
        reddit_force_json: -> { ForceJson },
        reddit_modhash: -> { Modhash },
        reddit_rate_limit: -> { RateLimit }
    end
  end
end
