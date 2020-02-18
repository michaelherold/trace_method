# frozen_string_literal: true

require_relative 'caller_extractor'

module Tracer
  module Module
    def self.new(*methods)
      ::Module.new do
        define_singleton_method(:__tracer__?) { true }
        define_singleton_method(:inspect) { "Tracer(#{instance_methods.sort.join(', ')})" }

        Module.define_methods_on(self, *methods)
      end
    end

    def self.define_methods_on(mod, *methods)
      methods.each do |method_name|
        mod.define_method method_name do |*args, &blk|
          trace = Tracer::CallerExtractor.call(caller)
          line, *_context = trace.split(/:in `/)
          line = line.delete_prefix(Tracer.config.app_root) if Tracer.config.app_root?

          Tracer.config.adapter.store_caller self.class.name, method_name, line

          super(*args, &blk)
        end
      end
    end
  end
end
