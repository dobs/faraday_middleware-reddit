require 'faraday/error'

module FaradayMiddleware
  module Reddit
    class TooManyRequestsError    < Faraday::ClientError; end # HTTP Status 429
    class BadGatewayError         < Faraday::ClientError; end # HTTP Status 502
    class ServiceUnavailableError < Faraday::ClientError; end # HTTP Status 503
    class GatewayTimeoutError     < Faraday::ClientError; end # HTTP Status 504

    RETRIABLE_ERRORS = [ServiceUnavailableError, GatewayTimeoutError]
  end
end