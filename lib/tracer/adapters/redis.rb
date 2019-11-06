begin
  require 'redis'
rescue LoadError
  warn "In order to use the Redis adapter, you must have the `redis' gem"
end

module Tracer
  module Adapters
    class Redis < Base
      def initialize(configuration)
        @base_key = 'tracer'
        @client = ::Redis.new(configuration)
        @expiry = 60 * 60 * 24 * 90
      end

      def fetch_callers(mod, method_name)
        client.smembers as_key(base_key, *mod.split('::'), method_name)
      end

      def fetch_traces(mod)
        client.smembers as_key(base_key, *mod.split('::'))
      end

      def store_caller(mod, method_name, calling_line)
        namespace = as_key base_key, *mod.split('::')
        method_key = as_key namespace, method_name

        client.pipelined do
          client.sadd namespace, method_name
          client.sadd method_key, calling_line

          client.expire namespace, expiry
          client.expire method_key, expiry
        end
      end

      private

      attr_reader :base_key
      attr_reader :client
      attr_reader :expiry

      def as_key(*pieces)
        pieces.join(':')
      end
    end
  end
end
