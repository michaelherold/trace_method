# frozen_string_literal: true

begin
  require 'redis'
rescue LoadError
  warn "In order to use the Redis adapter, you must have the `redis' gem"
end

module Tracer
  module Adapters
    class Redis < Base
      DEFAULT_EXPIRY = 60 * 60 * 24 * 90

      def initialize(configuration)
        @base_key = 'tracer'
        @client = ::Redis.new(configuration)
        @expiry = DEFAULT_EXPIRY
      end

      attr_reader :expiry

      def clear
        client.smembers(base_key).each(&method(:clear_namespace))
        client.del base_key
      end

      def fetch_callers(mod, method_name)
        client.smembers as_key(base_key, mod.split('::'), method_name)
      end

      def fetch_traces(mod)
        client.smembers as_key(base_key, mod.split('::'))
      end

      def fetch_traced_callers(mod)
        traces = fetch_traces(mod)
        result = {}

        client.pipelined do
          traces.each do |method_name|
            result[method_name] = fetch_callers mod, method_name
          end
        end

        result.transform_values!(&:value)
        result
      end

      def store_caller(mod, method_name, calling_line)
        namespace = as_key base_key, mod.split('::')
        method_key = as_key namespace, method_name

        client.pipelined do
          client.sadd base_key, namespace
          client.sadd namespace, method_name
          client.sadd method_key, calling_line

          client.expire base_key, expiry
          client.expire namespace, expiry
          client.expire method_key, expiry
        end
      end

      private

      attr_reader :base_key
      attr_reader :client

      def as_key(*pieces)
        pieces.join(':')
      end

      def clear_namespace(namespace)
        members = client.smembers(namespace)

        client.pipelined do
          members.each { |method_name| client.del as_key(namespace, method_name) }
          client.del namespace
        end
      end
    end
  end
end
