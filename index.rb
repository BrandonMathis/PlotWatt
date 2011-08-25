require 'sinatra'
require 'mongo'
require 'mongoid'

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
  "hello"
end
