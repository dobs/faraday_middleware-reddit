require 'faraday'

module FaradayMiddleware
  module RedditApi
    autoload :Authentication, 'faraday_middleware/reddit_api/request/authentication'
    autoload :ForceJson,      'faraday_middleware/reddit_api/request/force_json'
    autoload :Modhash,        'faraday_middleware/reddit_api/use/modhash'
    autoload :RateLimit,      'faraday_middleware/reddit_api/use/rate_limit'

    if Faraday.respond_to? :register_middleware
      Faraday.register_middleware :request,
        :reddit_authentication => lambda { Authentication },
        :reddit_force_json     => lambda { ForceJson }
      Faraday.register_middleware \
        :reddit_modhash        => lambda { Modhash },
        :reddit_rate_limit     => lambda { RateLimit }
    end
  end
end
