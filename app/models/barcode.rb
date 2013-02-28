class Barcode < ActiveRecord::Base
  attr_accessible :barcode, :barcode_set
  validates :barcode, presence: true
  validates :barcode, uniqueness: true
  validates :barcode_set, numericality: { only_integer: true }


  # Generate a set of random barcode strings
  # @param n Integer The number of barcodes to create (default=1)
  # @param l Integer The 
  # @return Array  An array of random barcode strings.
  def self.generate_barcodes(n=1)
    barcodes = []
    retry_count = 0
    bcset = Barcode.maximum("barcode_set").to_i + 1
    1.upto(n) do |m|
      begin
        bcid = "P#{ rand(16**5).to_s(16).upcase }"
        bc = Barcode.where(barcode: bcid).first_or_create!
        bc.barcode_set = bcset
        bc.save!
        barcodes << bc
      rescue ActiveRecord::RecordInvalid => e
        puts e.message
      end
    end
    barcodes
  end
end
