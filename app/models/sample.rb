# == Schema Information
#
# Table name: samples
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  taxon_id                :integer
#  container_id            :integer
#  container_x             :integer
#  container_y             :integer
#  protocol_application_id :integer
#  tags                    :string(500)
#  notes                   :text
#  retired                 :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Sample < ActiveRecord::Base
  attr_accessible :name,
    :taxon, :taxon_id,
    :scientific_name, :common_name,
    :ancestry, :container_x, :container_y,
    :protocol_application, :protocol_application_id,
    :tags, :notes, :retired

  serialize :tags
  default_scope where(retired: false)

  # validates :name, presence: true
  has_one :barcode, as: :barcodeable
  belongs_to :container
  belongs_to :protocol_application
  belongs_to :taxon

  def scientific_name
    taxon.try(:scientific_name)
  end
  def common_name
    taxon.try(:common_name)
  end

  def scientific_name=(sn)
    self.taxon = Taxon.find_by_scientific_name(sn)
  end

  # Sample hierarchy is represented (loosely) as a directed acyclic graph.
  # This is not strictly correct, but serves better for our purposes than a
  # strict tree hiearchy.
  has_dag_links link_class_name: 'SampleRelationship'

  # Full text search of samples
  include PgSearch
  multisearchable against: [:name, :tags, :notes],
    using: {
      tsearch: {
        any_word: true,
        prefix: true,
        tsvector_column: 'tsv_content'
      }
    }

  # versioned records
  has_paper_trail

  before_create :assign_barcode
  private
  def assign_barcode
      self.barcode ||= Barcode.generate()
  end

end
