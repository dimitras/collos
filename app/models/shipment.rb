# == Schema Information
#
# Table name: shipments
#
#  id              :integer          not null, primary key
#  barcode_string  :string(255)
#  tracking_number :string(255)
#  shipper_id      :integer
#  receiver_id     :integer
#  ship_date       :datetime
#  recieve_date    :datetime
#  tags            :string(500)
#  notes           :string(500)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tsv_content     :tsvector
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

  before_create :assign_barcode
  def assign_barcode
      bc = Barcode.generate()
      self.barcode_string = bc.barcode
      self.barcode = bc
  end

  # Full text search of samples
  include PgSearch
  multisearchable against: [:name, :barcode_string, :tags, :notes],
    using: {
      tsearch: {
        dictionary: "english",
        any_word: true,
        prefix: true,
        tsvector_column: 'tsv_content'
      }
    }
  pg_search_scope :search, against:  [:name, :barcode_string, :tags, :notes],
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
