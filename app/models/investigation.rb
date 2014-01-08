# == Schema Information
#
# Table name: investigations
#
#  id         :integer          not null, primary key
#  name       :text
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  study_id   :integer
#

class Investigation < ActiveRecord::Base
	attr_accessible :name, :person_id, :study_id

  	belongs_to :study
	has_many :samples
	has_and_belongs_to_many :people

end
