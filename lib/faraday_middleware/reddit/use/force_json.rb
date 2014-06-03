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
        case env[:method].to_s
        when 'get'
          env[:url].path += '.json' unless env[:url].path.end_with?('.json')
        when 'post'
          env[:body] = (env[:body] || '') + 'api_type=json' unless env[:body] && env[:body].include?('api_type')
        end

        @app.call(env)
      end
    end
  end
end
