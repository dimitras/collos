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

  # Generate a single uniq barcode
  def self.generate(barcode_set_id=nil)
    barcode_set_id ||= Barcode.maximum("barcode_set").to_i + 1
    retry_count = 0
    barcode = nil
    begin
      bcid = "P#{ rand(16**6).to_s(16).upcase }"
      barcode = Barcode.create!(barcode: bcid, barcode_set: barcode_set_id)
    rescue ActiveRecord::RecordInvalid => e
      logger.error(e.message)
      retry_count += 1
      retry if retry_count < 5
    end
    barcode
  end

  # Generate a set of random barcode strings
  # @param n Integer The number of barcodes to create (default=1)
  # @param l Integer The barcode_set_id
  # @return Array  An array of random barcode strings.
  def self.generate_barcodes(num,barcode_set_id=nil)
    barcodes = []
    retry_count = 0
    barcode_set_id ||= Barcode.maximum("barcode_set").to_i + 1
    (0...(num)).each do |m|
      retry_count = 0
      begin
        bc = self.generate(barcode_set_id)
        barcodes << bc
      rescue ActiveRecord::RecordInvalid => e
        logger.error(e.message)
        retry_count += 1
        retry if retry_count < 5
      end
    end
    return [barcode_set_id, barcodes]
  end

  def to_s
    barcode
  end
  
	def create_img
		require 'zint'
		# qrcode = Zint::Barcode.new(self.barcode, Zint::BARCODE_QRCODE) 
		qrcode = Zint::Barcode.new(self.barcode, Zint::BARCODE_MICROQR, :text=self.barcode, :option_2=1)
		png_path = "qr_codes/" + self.barcode + ".png"
		qrcode.path = "app/assets/images/" + png_path
		qrcode.print!
		return png_path
	end
end
