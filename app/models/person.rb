# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  type        :string(255)
#  institution :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email       :string(255)
#  phone       :integer
#

class Person < ActiveRecord::Base
	attr_accessible :institution, :name, :type, :email, :phone 

	has_and_belongs_to_many :studies
	has_and_belongs_to_many :investigations
end
