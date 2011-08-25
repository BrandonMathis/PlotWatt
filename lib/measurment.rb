class Measurment
  include Mongoid::Document
  field :always_on, :type => Integer
  field :ac, :type => Integer
  field :refrigeration, :type => Integer
  field :dryer, :type => Integer
  field :cooking, :type => Integer
  field :other, :type => Integer
  field :datetime, :type => DateTime

  def self.field_names
    fields.reject { |name, field| name =~ /_id(s?)$/ || name == "_type" }.collect { |name, field| name.to_sym }
  end
end
