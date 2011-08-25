require 'sinatra'
require 'mongo'
require 'mongoid'
require 'haml'
require 'awesome_print'
require 'gchart'


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

get '/raw_data' do
  @fields = Measurment.field_names
  @measurments = Measurment.find(:all)
  haml :raw_data
end

get '/' do
  measurments = Measurment.find(:all)
  total_over_time = measurments.map { |meas| meas.total_usage }
  labels = measurments.map { |meas| meas.collected.to_s }
  @line=Gchart.line(:size => '900x300',
            :title => "Energy Usage",
            :bg => 'efefef',
            :legend => ['Total Usage'],
            :data => total_over_time,
            )
  @pie=Gchart.pie_3d(
    :size => '900x300',
    :title => "Total Usage",
    :data => Measurment.totals,
    :labels => ["Always on", "Heating & A/C", "Refrigeration", "Dryer", "Cooking", "Other"]
  )
  haml :index
end
