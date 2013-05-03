# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  fname      :string(255)
#  lname      :string(255)
#  email      :string(255)
#  address_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base
  has_one :user
  belongs_to :address
  attr_accessible :email, :fname, :lname
end
