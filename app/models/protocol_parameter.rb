class ProtocolParameter < ActiveRecord::Base
  belongs_to :protocol
  belongs_to :unit_type
  attr_accessible :default_value, :description, :name, :unit
end
