require 'faraday'

module FaradayMiddleware
  module RedditApi
    autoload :Modhash,              'faraday_middleware/reddit_api/request/modhash'
    autoload :Authentication, 'faraday_middleware/reddit_api/request/authentication'

    if Faraday.respond_to? :register_middleware
      Faraday.register_middleware :request,
        :reddit_modhash        => lambda { Modhash },
        :reddit_authentication => lambda { Authentication }
    end
  end
end
