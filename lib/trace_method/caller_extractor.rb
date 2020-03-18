# frozen_string_literal: true

module TraceMethod
  module CallerExtractor
    def self.call(lines)
      lines.find { |line| line.match?(matcher) }
    end

    private_class_method def self.matcher
      config = TraceMethod.config
      return Regexp.new('.*') unless (root = config.app_root)

      ignores = Array(config.ignored)

      if ignores.empty?
        Regexp.new("^#{root}")
      else
        Regexp.new("^#{root}/(?!#{ignores.join('|')})")
      end
    end
  end
end
