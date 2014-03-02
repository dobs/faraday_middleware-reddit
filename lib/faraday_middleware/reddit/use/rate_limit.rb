require 'faraday'

module FaradayMiddleware::Reddit
  # Middleware for automatic rate limiting.
  #
  # Logs reddit's ratelimit HTTP headers and applies a caching strategy
  # based on them. The default strategy is to block for x-ratelimit-reset /
  # x-ratelimit_remaining.
  class RateLimit < Faraday::Middleware
    def initialize(app, options = nil)
      super(app)
      @options = options || {}
      @strategy = @options[:strategy] || lambda { linear_strategy }

      # Default rate limit settings.
      @ratelimit_remaining = 30
      @ratelimit_used      = 0
      @ratelimit_reset     = 60
      @ratelimit_cap       = 30
    end

    def call(env)
      if @ratelimit_remaining <= 0 || env[:status] == 429
        sleep(@ratelimit_reset)
      else
        @strategy.call
      end

      @app.call(env).on_complete do |env|
        @ratelimit_remaining = env[:response_headers]['x-ratelimit-remaining'].to_i
        @ratelimit_used      = env[:response_headers]['x-ratelimit-used'].to_i
        @ratelimit_reset     = env[:response_headers]['x-ratelimit-reset'].to_i
        @ratelimit_cap       = @ratelimit_remaining + @ratelimit_used
      end
    end

    def linear_strategy
      sleep (@ratelimit_reset.to_f / [1, @ratelimit_remaining].max)
    end

    def burst_strategy(threshold = 0.5)
      if (@ratelimit_used / @ratelimit_cap.to_f) > threshold
        linear_strategy
      end
    end
  end
end
