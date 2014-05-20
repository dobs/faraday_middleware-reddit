# encoding: utf-8

require 'faraday'

module FaradayMiddleware
  module Reddit
    # Middleware for automatic rate limiting.
    #
    # Logs reddit's ratelimit HTTP headers and applies a caching strategy
    # based on them. The default strategy is to block for x-ratelimit-reset /
    # x-ratelimit-remaining.
    class RateLimit < Faraday::Middleware
      def initialize(app, options = nil)
        super(app)
        @options = options || {}
        @strategy = @options[:strategy] || -> { burst_strategy }

        # Default rate limit settings.
        @ratelimit_remaining = 30
        @ratelimit_used      = 0
        @ratelimit_reset     = 60
        @ratelimit_cap       = 30
      end

      def call(env)
        @strategy.call
        @app.call(env).on_complete { |response_env| on_complete_callback(response_env) }
      end

      def on_complete_callback(env)
        @ratelimit_remaining = env[:response_headers]['x-ratelimit-remaining'].to_i
        @ratelimit_used      = env[:response_headers]['x-ratelimit-used'].to_i
        @ratelimit_reset     = env[:response_headers]['x-ratelimit-reset'].to_i
        @ratelimit_cap       = @ratelimit_remaining + @ratelimit_used

        sleep(@ratelimit_reset) if @ratelimit_remaining == 0 || env[:status] == 429
      end

      def linear_strategy
        sleep @ratelimit_reset.to_f / [1, @ratelimit_remaining].max
      end

      def burst_strategy(threshold = 0.5)
        linear_strategy if (@ratelimit_used / @ratelimit_cap.to_f) > threshold
      end
    end
  end
end
