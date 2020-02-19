# frozen_string_literal: true

module TraceMethod
  module CallerExtractor
    def self.call(lines)
      if (matcher = construct_matcher)
        lines.find { |line| line.match?(matcher) }
      else
        lines.first
      end
    end

    private_class_method def self.construct_matcher
      return unless (root = TraceMethod.config.app_root)

      ignores = Array(TraceMethod.config.ignored)

      if ignores.empty?
        Regexp.new("^#{root}")
      else
        Regexp.new("^#{root}/(?!#{ignores.join('|')})")
      end
    end
  end
end
