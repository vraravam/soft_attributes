module SoftAttributes
  module Base
    def self.included(base)
      base.class_eval do
        # TODO: Support serializable_hash (rails 3)
        def to_xml_with_soft_attributes(opts={})
          attributes_to_include = []
          self.soft_attributes.each do |k, v|
            next if !v.has_key?(:include_in_xml)
            if v[:include_in_xml].is_a?(Proc)
              attributes_to_include << k if !v[:include_in_xml].call(self).nil?
            else
              attributes_to_include << k if v[:include_in_xml] == true
            end
          end
          to_xml_without_soft_attributes(opts) do |xml|
            attributes_to_include.each do |attr|
              xml.tag!(attr, self.send(attr))
            end
          end
        end
        alias_method_chain :to_xml, :soft_attributes

        extend SoftAttributes::Base::ClassMethods
        include SoftAttributes::Base::InstanceMethods
      end
    end

    module ClassMethods
      def soft_attribute(*args)
        options = args.extract_options!
        attr = args.first
        options.assert_valid_keys(:include_in_xml, :value)

        __send__(:noop_setter, attr)
        soft_attributes[attr.to_s] = options.slice(:include_in_xml, :value)
      end

      def soft_attributes
        read_inheritable_attribute(:soft_attributes) || write_inheritable_hash(:soft_attributes, {})
      end
    end

    module InstanceMethods
      def soft_attributes
        @soft_attributes ||= self.class.soft_attributes.clone
        @soft_attributes.stringify_keys!
        @soft_attributes
      end

      def soft_attributes=(new_value)
        soft_attributes.merge!(new_value)
        soft_attributes   # return the merged hash
      end

      def respond_to?(method_symbol, include_private = false) #:nodoc:
        attr_name = extract_attr_name_without_equals(method_symbol)
        self.soft_attributes.has_key?(attr_name) || super
      end

      private
      def method_missing(method_symbol, *parameters) #:nodoc:
        if respond_to?(method_symbol) && !method_symbol.to_s.end_with?("=") #getter
          attr_name = extract_attr_name_without_equals(method_symbol)
          value = self.soft_attributes[attr_name][:value]
          return value.is_a?(Proc) ? value.call(self) : value
        end
        super
      end

      def extract_attr_name_without_equals(method_symbol) #:nodoc:
        str = method_symbol.to_s
        attr_name = str.end_with?("=") ? str.chop : str
        attr_name.slice!(0) if attr_name.start_with?("_")   # Rails 3 compatibility
        attr_name
      end
    end
  end
end

# TODO: maybe we could send this on ActiveModel?
require 'active_record'
require 'active_resource'
ActiveRecord::Base.send(:include, SoftAttributes::Base)
ActiveResource::Base.send(:include, SoftAttributes::Base)
