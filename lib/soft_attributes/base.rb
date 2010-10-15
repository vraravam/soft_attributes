module SoftAttributes
  module Base
    def self.included(base)
      base.class_eval do
        extend SoftAttributes::Base::ClassMethods
        include SoftAttributes::Base::InstanceMethods
      end
    end

    module ClassMethods
      def soft_attribute(*args)
        options = args.extract_options!
        attr = args.first
        options.assert_valid_keys(:include_in_xml, :value)

        send(:noop_setter, attr)
        soft_attributes[attr.to_s] = options.slice(:include_in_xml, :value)
      end

      def soft_attributes
        @soft_attributes ||= {}
      end
    end

    module InstanceMethods
      def respond_to?(method_symbol, include_private = false) #:nodoc:
        attr_name = extract_attr_name_without_equals(method_symbol)
        self.class.soft_attributes.has_key?(attr_name) || super
      end

      private
      def method_missing(method_symbol, *parameters) #:nodoc:
        return self.class.soft_attributes[extract_attr_name_without_equals(method_symbol)][:value].call(self) if respond_to?(method_symbol) && method_symbol.to_s.last != '=' #getter
        super
      end

      def extract_attr_name_without_equals(method_symbol) #:nodoc:
        method_symbol.to_s.last == '=' ? method_symbol.to_s.first(-1) : method_symbol.to_s
      end
    end
  end
end

# TODO: maybe we could send this on ActiveSupport
require 'active_record'
require 'active_resource'
ActiveRecord::Base.send(:include, SoftAttributes::Base)
ActiveResource::Base.send(:include, SoftAttributes::Base)
