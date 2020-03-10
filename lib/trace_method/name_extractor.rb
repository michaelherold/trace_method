# frozen_string_literal: true

module TraceMethod
  module NameExtractor
    def self.call(mod)
      return mod.class.name unless mod.is_a? Class

      case (name = mod.name)
      when String then "Class::#{name}"
      else mod.inspect.delete_prefix('#<').delete_suffix('>').tr(':', '')
      end
    end
  end
end
