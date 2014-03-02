require 'faraday'

module FaradayMiddleware::Reddit
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
        if env[:body].is_a? Hash
          env[:body][:api_type] = 'json'
        else
          env[:body] = [env[:body], 'api_type=json'].compact.join('&')
        end
      end

      @app.call(env)
    end
  end
end
