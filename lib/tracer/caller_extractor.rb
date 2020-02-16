# frozen_string_literal: true

module Tracer
  module CallerExtractor
    def self.call(lines)
      if (matcher = construct_matcher)
        lines.find { |line| line.match?(matcher) }
      else
        lines.first
      end
    end

    private_class_method def self.construct_matcher
      return unless (root = Tracer.config.app_root)

      ignores = Array(Tracer.config.ignored)

      if ignores.empty?
        Regexp.new("^#{root}")
      else
        Regexp.new("^#{root}/(?!#{ignores.join('|')})")
      end
    end
  end
end
