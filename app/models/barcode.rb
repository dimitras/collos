# == Schema Information
#
# Table name: barcodes
#
#  id               :integer          not null, primary key
#  barcode          :string(255)
#  barcode_set      :integer          default(0)
#  barcodeable_id   :integer
#  barcodeable_type :string(255)
#

class Barcode < ActiveRecord::Base
  attr_accessible :barcode, :barcode_set
  validates :barcode, presence: true
  validates :barcode, uniqueness: true
  validates :barcode_set, numericality: { only_integer: true }

  belongs_to :barcodeable, polymorphic: true
  # has_many :samples
  # has_many :containers

  # Generate a set of random barcode strings
  # @param n Integer The number of barcodes to create (default=1)
  # @param l Integer The
  # @return Array  An array of random barcode strings.
  def self.generate_barcodes(num,barcode_set=nil)
    barcodes = []
    retry_count = 0
    barcode_set ||= Barcode.maximum("barcode_set").to_i + 1
    (0...(num)).each do |m|
      retry_count = 0
      begin
        bcid = "P#{ rand(16**6).to_s(16).upcase }"
        bc = Barcode.create!(barcode: bcid, barcode_set: barcode_set)
        barcodes << bc
      rescue ActiveRecord::RecordInvalid => e
        logger.error(e.message)
        retry_count += 1
        retry if retry_count < 5
      end
    end
    return [barcode_set, barcodes]
  end
end
