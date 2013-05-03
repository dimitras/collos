# == Schema Information
#
# Table name: protocols
#
#  id               :integer          not null, primary key
#  protocol_type_id :integer
#  name             :string(255)
#  description      :string(255)
#  accession        :string(255)
#  uri              :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Protocol < ActiveRecord::Base
  attr_accessible :accession, :description, :name, :uri

  belongs_to :protocol_type, :class_name => "OntologyTerm", :foreign_key => "protocol_type_id"
  has_many :protocol_applications
  has_many :protocol_parameters

end
