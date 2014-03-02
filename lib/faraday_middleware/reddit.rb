require 'faraday'

module FaradayMiddleware
  module Reddit
    autoload :Authentication, 'faraday_middleware/reddit/request/authentication'
    autoload :ForceJson,      'faraday_middleware/reddit/request/force_json'
    autoload :Modhash,        'faraday_middleware/reddit/use/modhash'
    autoload :RateLimit,      'faraday_middleware/reddit/use/rate_limit'

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
