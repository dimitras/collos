# == Schema Information
#
# Table name: shipments
#
#  id              :integer          not null, primary key
#  tracking_number :string(255)
#  shipper_id      :integer
#  receiver_id     :integer
#  ship_date       :datetime
#  recieve_date    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Shipment < ActiveRecord::Base
  attr_accessible :receiver_id, :reciever, :recieve_date, :ship_date, :shipper_id, :shipper, :tracking_number
  has_and_belongs_to_many :containers
  has_one :barcode, as: :barcodeable
  belongs_to :shipper, :class_name => "User", :foreign_key => "shipper_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"

  scope :open_shipments, where("ship_date <= ? and recieve_date is NULL",  Time.now())

  def shipper_address
    shipper.contact.address
  end
  def receiver_address
    receiver.contact.address
  end
end
