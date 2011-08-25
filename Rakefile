require 'rake'
require 'csv'
require 'pry'
require 'awesome_print'
require File.join(File.dirname(__FILE__), 'index.rb')

namespace :db do
  desc "load seed data into db"
  task :seed do
    if Measurment.find(:all).count == 0
      csv_into_mongo("plotwatt_appliance_data.csv")
      puts "Seed Data Loaded"
    else
      puts "Database is not empty! Seed data cannot be loaded! Run rake db:drop"
    end
  end
  task :drop do
    Mongoid.master.collections.reject { |c| c.name =~ /system.indexes/ }.each(&:drop)
    puts "Database Emptied. Run rake db:seed to load seed data"
  end
end

def csv_into_mongo(file)
  require 'time'
  attrs = {}
  measurments = CSV.read(file)
  measurments[1..measurments.length].each do |row|
    attrs = Hash.create(Measurment.field_names, row)
    attrs.each do |key, value|
      attrs[key] = value.to_f unless key == :collected
      if key == :collected
        attrs[key] = Time.parse(value.chomp) 
      end
    end
    Measurment.create(attrs)
  end
end

class << Hash
  def create(keys, values)
    self[*keys.zip(values).flatten]
  end
end
