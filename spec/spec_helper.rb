ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','index.rb'))
require 'rspec/given'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  Mongoid.configure do |config|
    name = "PlotWatt_test"
    host = "localhost"
    config.master = Mongo::Connection.new.db(name)
    config.persist_in_safe_mode = false
  end

  config.before(:each) do
    Mongoid.master.collections.reject { |c| c.name =~ /system.indexes/ }.each(&:drop)
  end
end
