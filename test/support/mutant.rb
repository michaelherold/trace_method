# frozen_string_literal: true

if ENV['MUTANT']
  require 'mutant/minitest/coverage'

  module TraceMethodTests
    class TestCase
      def self.inherited(descendant)
        test_name = descendant.name
        covered_class = test_name.delete_suffix('Test')

        if defined?(covered_class)
          descendant.cover covered_class
        else
          warn "#{test_name} is misnamed because #{covered_class} does not exist"
        end

        super
      end
    end
  end
end
