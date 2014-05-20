require 'faraday_middleware/reddit/error'

module FaradayMiddleware
  module Reddit
    # Extended version of Faraday::Response::RaiseError
    #
    # Provides additional exception cases for common reddit errors, such as
    # 429 for hitting the API rate limit or 504 for gateway timeouts.
    class RaiseError < Faraday::Response::RaiseError
      def on_complete(env)
        case env[:status]
        when 429
          raise FaradayMiddleware::Reddit::TooManyRequestsError, response_values(env)
        when 502
          raise FaradayMiddleware::Reddit::BadGatewayError, response_values(env)
        when 503
          raise FaradayMiddleware::Reddit::ServiceUnavailableError, response_values(env)
        when 504
          raise FaradayMiddleware::Reddit::GatewayTimeoutError, response_values(env)
        end

        super
      end
    end
  end
end
