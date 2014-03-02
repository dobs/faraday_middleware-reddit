require 'faraday'

module FaradayMiddleware::RedditApi
  #

  AUTH_URL = 'https://ssl.reddit.com/post/login'.freeze

  class RedditAuthentication < Faraday::Middleware
    dependency do
      require 'json' unless defined?(::JSON)
    end

    def initialize(app, user, password, remember = true, cookie = nil)
      super(app)
      @user    = user
      @passwd  = password
      @rem     = remember
      @cookie  = cookie
    end

    def call(env)
      authenticate(env) unless @cookie
      set_cookie(env)
      @app.call(env)
    end

    def authenticate(env)
      response = Faraday.post AUTH_URL, {:user => @user, :passwd => @passwd, :rem => @rem, :api_type => 'json'}
      @cookie = response.headers['set-cookie']
    end

    def set_cookie(env)
      upstream_cookies = env[:request_headers]['Cookie']
      env[:request_headers]['Cookie'] = if upstream_cookies
        "#{upstream_cookies}; #{@cookie}"
      else
        @cookie
      end
    end
  end
end
