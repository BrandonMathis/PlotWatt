require 'sinatra'
require 'mongo'
require 'mongoid'
require 'haml'
require 'awesome_print'
require 'gchart'


Dir.glob("lib/**").each do |file|
  require File.join(File.dirname(__FILE__), file)
end

MONTHS = [nil, "Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"]

configure do
  Mongoid.configure do |config|
    name = "PlotWatt"
    host = "mongodb://KeysetTS:chunkybacon@staff.mongohq.com:10050/PlotWatt"
    connection = Mongo::Connection.from_uri(host)
    config.master = connection.db(name)
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
  @line = line_chart(measurments, :range => 'lifetime')
  @pie = total_pie_chart(Measurment.totals)
  monthly_measurments = {}
  MONTHS.each do |month|
    monthly_measurments[month] = Measurment.find_by_month(month)
  end
  haml :index
end

get '/energy/:month' do
  measurments = Measurment.find_by_month(params[:month])
  if measurments.empty?
    haml :no_usage
  elsif MONTHS.include?(params[:month])
    @line = line_chart(measurments, :range => params[:month])
    @pie = total_pie_chart(Measurment.totals_for_month(params[:month]))
    haml :month
  end
end

def total_pie_chart(totals)
  Gchart.pie_3d(
    :size => '900x300',
    :title => "Total Usage",
    :data => totals,
    :labels => ["Always on", "Heating & A/C", "Refrigeration", "Dryer", "Cooking", "Other"]
  )
end

def line_chart(measurments, opts = {})
  totals_over_time = measurments.map { |meas| meas.total_usage }
  # These axis lables may be a bit off but it is the best I can do for a prototype
  axis = ( MONTHS[9,12] + MONTHS[1,3] ).join('|') if opts[:range] == 'lifetime'
  axis = days_for_month opts[:range] if MONTHS.include?(opts[:range])
  Gchart.line(
    :size => '900x300',
    :title => "Energy Usage",
    :bg => 'efefef',
    :legend => ['Total Usage'],
    :data => totals_over_time,
    :axis_with_labels => 'x',
    :axis_labels => [axis]
  )
end

def days_for_month(month)
  if ["Sept", "April", "June", "Nov"].include?(month)
    return (1..30).to_a.join("|")
  elsif month == "Feb" 
    return (1..28).to_a.join("|")
  else
    return (1..31).to_a.join("|")
  end
end
