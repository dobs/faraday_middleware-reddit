require 'faraday'

module FaradayMiddleware
  module RedditApi
    autoload :Modhash,              'faraday_middleware/reddit_api/request/modhash'
    autoload :RedditAuthentication, 'faraday_middleware/reddit_api/request/reddit_authentication'

    if Faraday.respond_to? :register_middleware
      Faraday.register_middleware :request,
        :modhash               => lambda { Modhash },
        :reddit_authentication => lambda { RedditAuthentication }
    end
  end
end
