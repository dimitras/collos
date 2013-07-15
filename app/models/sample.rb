# == Schema Information
#
# Table name: samples
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  container_id            :integer
#  taxon_id                :integer
#  protocol_application_id :integer
#  ancestry                :string(255)
#  ancestry_depth          :integer          default(0)
#  notes                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Sample < ActiveRecord::Base
  attr_accessible :name, :notes, :taxon, :taxon_id,
    :ancestry, :protocol_application, :protocol_application_id, :scientific_name, :common_name

  # validates :name, presence: true

  has_one :barcode, as: :barcodeable
  belongs_to :container
  belongs_to :protocol_application
  belongs_to :taxon
  has_many :sample_characteristics

  has_ancestry :orphan_strategy => :rootify, :cache_depth => true
  has_paper_trail

  def scientific_name
    taxon.try(:scientific_name)
  end
  def common_name
    taxon.try(:common_name)
  end

  def scientific_name=(sn)
    self.taxon = Taxon.find_by_scientific_name(sn)
  end

  before_create :assign_barcode

  def assign_barcode
      self.barcode ||= Barcode.generate()
  end

end
