# == Schema Information
#
# Table name: investigations
#
#  id         :integer          not null, primary key
#  title      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  identifier :text
#

class Investigation < ActiveRecord::Base
	attr_accessible :title, :identifier

  	has_many :studies
	has_many :samples
	has_and_belongs_to_many :people

end
