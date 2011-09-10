require File.expand_path('../../spec_helper', __FILE__)
load 'soft_attributes/serialization.rb'

class Pong < ActiveRecord::Base
  soft_attribute :krishna, :value => "sis"
  soft_attribute :anand, :value => "bil", :include_in_xml => true
  soft_attribute :dittu, :value => "nep", :include_in_xml => Proc.new{ |r| r.name.nil? }
end

describe SoftAttributes::Serialization do
  before(:all) do
    require 'active_model/serialization'

    ActiveModel::Serialization.send(:include, SoftAttributes::Serialization)

    connection = ActiveRecord::Base.connection
    begin
      connection.create_table(:pongs) do |t|
        t.string :name
        t.string :application
      end
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.warn "Error in before(:each): #{e}" if defined?(RAILS_DEFAULT_LOGGER)
    end
  end

  after(:all) do
    begin
      connection = ActiveRecord::Base.connection
      connection.drop_table(Pong.table_name)
    rescue Exception => e
      RAILS_DEFAULT_LOGGER.warn "Error in after(:each): #{e}" if defined?(RAILS_DEFAULT_LOGGER)
    end
  end

  it "should define a method called serializable_hash_with_soft_attributes" do
    Pong.new.public_methods.include?(:serializable_hash_with_soft_attributes).should be_true
  end

  it "should not include a soft attribute that does not have the 'include_in_xml' key" do
    record = Pong.new
    record.serializable_hash.should_not have_key("krishna")
  end

  it "should include a soft attribute that does have the 'include_in_xml' key with a value of true" do
    record = Pong.new
    record.serializable_hash.should have_key("anand")
  end

  it "should include a soft attribute that does have the 'include_in_xml' key that evaluates to true from a Proc" do
    record = Pong.new
    record.serializable_hash.should have_key("dittu")

    record = Pong.new(:name => "some non nil")
    record.serializable_hash.should_not have_key("dittu")
  end
end
