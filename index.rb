require 'sinatra'
require 'mongo'
require 'mongoid'
require 'haml'

Dir.glob("lib/**").each do |file|
  require File.join(File.dirname(__FILE__), file)
end

configure do
   Mongoid.configure do |config|
    name = "PlotWatt"
    host = "localhost"
    config.master = Mongo::Connection.new.db(name)
    config.persist_in_safe_mode = false
  end
end

get '/' do
  @fields = Measurment.field_names
  @measurments = Measurment.find(:all)
  haml :index
end
