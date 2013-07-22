# == Schema Information
#
# Table name: addresses_users
#
#  address_id :integer          not null
#  user_id    :integer          not null
#

class AddressesUsers < ActiveRecord::Base
  attr_accessible :address_id, :user_id
end
