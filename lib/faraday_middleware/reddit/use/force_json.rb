# encoding: utf-8

require 'faraday'

module FaradayMiddleware
  module Reddit
    # Request middleware to force reddit to provide JSON responses when
    # available.
    #
    # For GET requests that means adding `.json` to  the ends of URLs. For POST
    # requests that means adding `api_type=json` to sent requests.
    class ForceJson < Faraday::Middleware
      def initialize(app, options = nil)
        super(app)
        @options = options || {}
      end

      def call(env)
        if env[:method].to_s == 'get'
          env[:url].path += '.json' unless env[:url].path.end_with?('.json')
        elsif env[:method].to_s == 'post'
          env[:body] = [env[:body], 'api_type=json'].compact.join('&')
        end

        @app.call(env)
      end
    end
  end
end
