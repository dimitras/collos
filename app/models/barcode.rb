# == Schema Information
#
# Table name: barcodes
#
#  id          :integer          not null, primary key
#  barcode     :string(255)
#  barcode_set :integer          default(0)
#

class Barcode < ActiveRecord::Base
  attr_accessible :barcode, :barcode_set
  validates :barcode, presence: true
  validates :barcode, uniqueness: true
  validates :barcode_set, numericality: { only_integer: true }

  has_many :samples
  has_many :containers

  # Generate a set of random barcode strings
  # @param n Integer The number of barcodes to create (default=1)
  # @param l Integer The
  # @return Array  An array of random barcode strings.
  def self.generate_barcodes(n=1)
    barcodes = []
    retry_count = 0
    bcset = Barcode.maximum("barcode_set").to_i + 1
    1.upto(n) do |m|
      retry_count = 0
      begin
        bcid = "P#{ rand(16**6).to_s(16).upcase }"
        bc = Barcode.create!(barcode: bcid, barcode_set: bcset)
        barcodes << bc
      rescue ActiveRecord::RecordInvalid => e
        logger.error(e.message)
        retry_count += 1
        retry if retry_count < 5
      end
    end
    barcodes
  end
end
