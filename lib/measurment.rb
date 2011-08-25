class Measurment
  include Mongoid::Document
  field :always_on, :type => Integer
  field :ac, :type => Integer
  field :refrigeration, :type => Integer
  field :dryer, :type => Integer
  field :cooking, :type => Integer
  field :other, :type => Integer
  field :collected, :type => String

  def self.field_names
    fields.reject { |name, field| name =~ /_id(s?)$/ || name == "_type" }.collect { |name, field| name.to_sym }
  end

  def self.totals
    totals = {:always_on => 0, :ac => 0, :refrigeration => 0, :dryer => 0, :cooking => 0, :other => 0}
    measurments = find(:all)
    measurments.each do |meas|
      totals.each do |key, value|
        totals[key] = totals[key] + meas.send(key)
      end
    end
    totals.values
  end

  def total_usage
    self.always_on + self.ac + self.refrigeration + self.dryer + self.cooking + self.other
  end
end
