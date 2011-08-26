class Measurment
  include Mongoid::Document
  field :always_on, :type => Integer
  field :ac, :type => Integer
  field :refrigeration, :type => Integer
  field :dryer, :type => Integer
  field :cooking, :type => Integer
  field :other, :type => Integer
  field :collected, :type => DateTime

  def self.field_names
    fields.reject { |name, field| name =~ /_id(s?)$/ || name == "_type" }.collect { |name, field| name.to_sym }
  end

  def self.totals_for_month(month)
    measurments = Measurment.find_by_month(month)
    totals = Measurment.summarize(measurments)
  end

  def self.totals
    Measurment.summarize(find(:all))
  end

  def self.summarize(measurments)
    totals = {:always_on => 0, :ac => 0, :refrigeration => 0, :dryer => 0, :cooking => 0, :other => 0}
    measurments.each do |meas|
      totals.each do |key, value|
        totals[key] = totals[key] + meas.send(key) if meas.send(key)
      end
    end
    totals
  end

  def self.find_by_month(month)
    return nil unless MONTHS.include?(month)
    measurments = Measurment.find(:all)  # this query could be better
    measurments.select {|meas| meas.collected.month == MONTHS.index(month)}
  end

  def total_usage
    self.always_on + self.ac + self.refrigeration + self.dryer + self.cooking + self.other
  end
end
