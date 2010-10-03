# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"

require File.expand_path(File.dirname(__FILE__) + '/../../../../config/environment')
require 'spec'
require 'spec/rails'
require 'mocha'
require File.dirname(__FILE__) + "/../lib/soft_attributes"

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/vendor/plugins/soft_attributes/spec/fixtures/'
  config.mock_with :mocha

  config.before(:all) do
    ActiveRecord::Base.connection.create_table :soft_attributes_items, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end

  config.after(:all) do
    ActiveRecord::Base.connection.drop_table :soft_attributes_items
  end

  config.before(:each) do
    class SoftAttributesItem < ActiveRecord::Base
    end
  end

  config.after(:each) do
    Object.send(:remove_const, :SoftAttributesItem)
  end
end

def putsh(stuff)
  puts "#{ERB::Util.h(stuff)}<br/>"
end

def ph(stuff)
  putsh stuff.inspect
end
