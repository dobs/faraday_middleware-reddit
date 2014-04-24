require 'faraday'

module FaradayMiddleware
  module Reddit
    autoload :Authentication, 'faraday_middleware/reddit/request/authentication'
    autoload :ForceJson,      'faraday_middleware/reddit/use/force_json'
    autoload :Modhash,        'faraday_middleware/reddit/use/modhash'
    autoload :RateLimit,      'faraday_middleware/reddit/use/rate_limit'

    if Faraday::Middleware.respond_to? :register_middleware
      Faraday::Request.register_middleware \
        :reddit_authentication => lambda { Authentication }
      Faraday::Middleware.register_middleware \
        :reddit_force_json     => lambda { ForceJson },
        :reddit_modhash        => lambda { Modhash },
        :reddit_rate_limit     => lambda { RateLimit }
    end
  end
end
