class ProtocolApplication < ActiveRecord::Base
  belongs_to :protocol
  belongs_to :operator
  attr_accessible :procedure_date
end
