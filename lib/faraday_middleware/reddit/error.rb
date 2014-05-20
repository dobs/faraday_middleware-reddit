require 'faraday/error'

module FaradayMiddleware
  module Reddit
    class ClientError < Faraday::ClientError; end
    class ServerError < Faraday::ClientError; end

    # Many of these errors are hypothetical, but better safe than sorry.
    class BadRequestError            < ClientError; end
    class UnauthorizedError          < ClientError; end
    class ForbiddenError             < ClientError; end
    class NotFoundError              < ClientError; end
    class MethodNotAllowedError      < ClientError; end
    class NotAcceptableError         < ClientError; end
    class RequestTimeoutError        < ClientError; end
    class RequestEntityTooLargeError < ClientError; end
    class RequestURITooLongError     < ClientError; end
    class UnsupportedMediaTypeError  < ClientError; end
    class TooManyRequestsError       < ClientError; end
    class InternalServerError        < ServerError; end
    class NotImplementedError        < ServerError; end
    class BadGatewayError            < ServerError; end
    class ServiceUnavailableError    < ServerError; end
    class GatewayTimeoutError        < ServerError; end

    ERROR_CODES = {
      400 => BadRequestError,
      401 => UnauthorizedError,
      403 => ForbiddenError,
      404 => NotFoundError,
      405 => MethodNotAllowedError,
      406 => NotAcceptableError,
      408 => RequestTimeoutError,
      413 => RequestEntityTooLargeError,
      414 => RequestURITooLongError,
      429 => TooManyRequestsError,
      500 => InternalServerError,
      501 => NotImplementedError,
      502 => BadGatewayError,
      503 => ServiceUnavailableError,
      504 => GatewayTimeoutError
    }.freeze

    RETRIABLE_ERRORS = [
      ServiceUnavailableError,
      GatewayTimeoutError
    ].freeze
  end
end