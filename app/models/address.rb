# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  line_1     :string(255)
#  line_2     :string(255)
#  line_3     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  province   :string(255)
#  country    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Address < ActiveRecord::Base
  attr_accessible :city, :country, :line_1, :line_2, :line_3, :province, :state, :zip
  has_many :contacts

end
