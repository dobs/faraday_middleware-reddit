require 'faraday_middleware/reddit/error'

module FaradayMiddleware
  module Reddit
    # Extended version of Faraday::Response::RaiseError
    #
    # Provides additional exception cases for common reddit errors, such as
    # 429 for hitting the API rate limit or 504 for gateway timeouts.
    class RaiseError < Faraday::Response::RaiseError
      def on_complete(env)
        if FaradayMiddleware::Reddit::ERROR_CODES.include? env[:status]
          raise FaradayMiddleware::Reddit::ERROR_CODES[env[:status]], response_values(env)
        else
          super
        end
      end
    end
  end
end
