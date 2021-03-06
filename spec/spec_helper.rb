# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"

require 'rubygems'
require 'bundler/setup'
require 'mocha'
require "nokogiri"
require "webrat/core/matchers/have_tag"
require 'soft_attributes'

RSpec.configure do |config|
  config.mock_with :mocha
  config.include(Webrat::Matchers)
  config.include(Webrat::HaveTagMatcher)
  include Webrat::HaveTagMatcher

  config.before(:all) do
    `touch db/test.sqlite3`
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :encoding => "utf8", :database => "db/test.sqlite3")

    ActiveRecord::Base.connection.create_table :soft_attributes_items, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end

  config.after(:all) do
    ActiveRecord::Base.connection.drop_table :soft_attributes_items
    `rm -f db/test.sqlite3`
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
