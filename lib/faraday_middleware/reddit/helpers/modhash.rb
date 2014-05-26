# encoding: utf-8

module FaradayMiddleware
  module Reddit
    module ModhashHelpers
      def self.included(base)
        base.dependency do
          require 'json' unless defined?(::JSON)
        end
      end

      def extract_modhash(env)
        return unless env[:body].include?('modhash')

        body = env[:body]
        body = JSON.parse(body) if body.is_a?(String) && !body.strip.empty?
        body = body['json'] if body.is_a?(Hash) && body['json']
        body['data']['modhash'] if body.is_a?(Hash) && body['data']
      end
    end
  end
end
