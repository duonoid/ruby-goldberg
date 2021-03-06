require 'forwardable'

module RG #:nodoc:
  module Adapters #:nodoc:

    class RedisAdapter < AbstractAdapter
      extend Forwardable

      def_delegators :@cache, :get, :set

      def initialize(config = {})
        require 'redis'
        @cache = Redis.new(config)
      end

    end

  end
end
