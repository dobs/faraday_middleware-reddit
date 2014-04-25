# encoding: utf-8

require 'faraday'

module FaradayMiddleware
  module Reddit
    # Middleware that keeps track of and sets modhash-related HTTP headers.
    #
    # Reddit uses modhashes as a form of XSS protection and requires them for
    # most POST and PUT requests. Modhashes are currently provided in response
    # to listing GET requests.
    class Modhash < Faraday::Middleware
      dependency do
        require 'json' unless defined?(::JSON)
      end

      def initialize(app, options = nil)
        super(app)
        @options = options || {}
        @modhash = @options[:modhash]
      end

      def call(env)
        @modhash = env[:modhash] if env[:modhash]
        env[:request_headers]['X-Modhash'] = @modhash if @modhash
        @app.call(env).on_complete do |response_env|
          update_modhash(response_env)
        end
      end

      def from_json(data)
        if data.is_a?(String) && !data.strip.empty? && data.include?('modhash')
          JSON.parse(data)
        else
          data
        end
      end

      def update_modhash(env)
        body = from_json(env[:body])
        @modhash = body['data']['modhash'] if body['data']
      rescue JSON::JSONError
        # Ignore -- modhash can be acquired lazily.
      end
    end
  end
end
