# == Schema Information
#
# Table name: shipments
#
#  id                :integer          not null, primary key
#  tracking_number   :string(255)
#  shipper_id        :integer
#  receiver_id       :integer
#  ship_date         :datetime
#  recieve_date      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  past_container    :string(255)
#  new_container     :string(255)
#  complete          :boolean
#  past_container_id :integer
#  new_container_id  :integer
#  tsv_content       :tsvector
#

class Shipment < ActiveRecord::Base
  attr_accessible :receiver_id, :receiver, :recieve_date, :ship_date, :shipper_id, :shipper, :tracking_number, :past_container, :new_container, :complete, :past_container_id, :new_container_id
  has_and_belongs_to_many :containers
  has_one :barcode, as: :barcodeable
  belongs_to :shipper, :class_name => "User", :foreign_key => "shipper_id"
  belongs_to :receiver, :class_name => "User", :foreign_key => "receiver_id"
  belongs_to :past_container, :class_name => "Container", :foreign_key => "past_container_id"
  belongs_to :new_container, :class_name => "Container", :foreign_key => "new_container_id"
  # has_one :container_change

  scope :open_shipments, where("ship_date <= ? and recieve_date is NULL",  Time.now())

  def shipper_address
    shipper.contact.address
  end
  def receiver_address
    receiver.contact.address
  end

  # Full text search of samples
  include PgSearch
  multisearchable against: [:tracking_number],
  using: {
    tsearch: {
      dictionary: "english",
      any_word: true,
      prefix: true,
      tsvector_column: 'tsv_content'
    }
  }

  pg_search_scope :search, against: [:tracking_number],
  using: {
    tsearch: {
      dictionary: "english",
      any_word: true,
      prefix: true,
      tsvector_column: 'tsv_content'
    }
  }

  # versioned records
  has_paper_trail
end
