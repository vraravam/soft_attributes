module SoftAttributes
  module NoopSetter
    def self.included(mod)
      mod.module_eval do
        class << self
          def noop_setter(*attrs)
            attrs.flatten.each do |attr|
              send(:define_method, "#{attr}=") {|ignore|}
            end
          end
        end
      end
    end
  end
end

# TODO: maybe we could send this on ActiveSupport
require 'active_record'
require 'active_resource'
ActiveRecord::Base.send(:include, SoftAttributes::NoopSetter)
ActiveResource::Base.send(:include, SoftAttributes::NoopSetter)
