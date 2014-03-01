require 'faraday'

module FaradayMiddleware
  module RedditApi
    autoload :Modhash, 'faraday_middleware/reddit_api/request/modhash'

    if Faraday.respond_to? :register_middleware
      Faraday.register_middleware :request,
        :modhash    => lambda { Modhash }
    end
  end
end
