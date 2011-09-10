module SoftAttributes
  module Serialization
    def self.included(base)
      base.class_eval do
        def serializable_hash_with_soft_attributes(opts={}) #:nodoc:
          attributes_to_include = self.soft_attributes.clone.with_indifferent_access.collect do |k, v|
            include_in_xml = v[:include_in_xml]
            if include_in_xml.present?
              k if (include_in_xml.is_a?(Proc) ? include_in_xml.call(self) : include_in_xml == true)
            end
          end.compact
          hash = attributes_to_include.inject({}) do |hash, attr|
            hash[attr] = self.send(attr)
            hash
          end
          serializable_hash_without_soft_attributes.merge(hash)
        end
        alias_method_chain :serializable_hash, :soft_attributes
      end
    end
  end
end

if defined?(Rails) && Rails::VERSION::MAJOR >= 3
  require 'active_model/serialization'

  ActiveModel::Serialization.send(:include, SoftAttributes::Serialization)
end
