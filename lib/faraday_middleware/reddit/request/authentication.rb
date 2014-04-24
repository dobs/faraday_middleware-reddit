# encoding: utf-8

require 'faraday'

module FaradayMiddleware
  module Reddit
    # Request middleware that automatically handles user login.
    #
    # Requires that either a `user` and `password` are provided or a
    # pre-generated `cookie`. Performs an additional login request when no
    # valid login cookie is available.
    class Authentication < Faraday::Middleware
      AUTH_URL = 'https://ssl.reddit.com/post/login'.freeze

      dependency do
        require 'json' unless defined?(::JSON)
      end

      def initialize(app, options)
        super(app)
        @options = options
        @user    = @options[:user]
        @passwd  = @options[:password]
        @rem     = @options[:remember]
        @cookie  = @options[:cookie]

        unless (@options[:user] && @options[:password]) || @options[:cookie]
          fail ArgumentError, 'Either `user` and `password` or `cookie` need to be provided as options to the :reddit_authentication middleware'
        end
      end

      def call(env)
        authenticate(env) unless @cookie
        apply_cookie(env)
        @app.call(env)
      end

      def authenticate(env)
        response = Faraday.post AUTH_URL, user: @user, passwd: @passwd, rem: @rem, api_type: 'json'
        @cookie = response.headers['set-cookie']
      end

      def apply_cookie(env)
        upstream_cookies = env[:request_headers]['Cookie']
        env[:request_headers]['Cookie'] = upstream_cookies ? "#{upstream_cookies}; #{@cookie}" : @cookie
      end
    end
  end
end
