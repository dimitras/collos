# == Schema Information
#
# Table name: samples
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  barcode_string          :string(255)
#  taxon_id                :integer
#  container_id            :integer
#  container_x             :integer          default(0)
#  container_y             :integer          default(0)
#  protocol_application_id :integer
#  tags                    :string(500)
#  notes                   :text
#  retired                 :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  tsv_content             :tsvector
#

class Sample < ActiveRecord::Base
  attr_accessible :name,
    :taxon, :taxon_id,
    :scientific_name, :common_name,
    :container, :container_id,
    :container_x, :container_y,
    :protocol_application, :protocol_application_id,
    :notes, :retired, :tags


  # Needed to parse out comma delimited tags from forms into a strict Array
  # def tags=(tgs)
  #   if tgs.kind_of? String
  #     tgs = [tgs]
  #   end
  #   tgs = tgs.collect{ |t| t.split(',')}.flatten.collect {|t| t.strip }
  #   write_attribute(:tags, tgs)
  # end

  # def tags
  #   t = read_attribute(:tags)
  #   if t.kind_of? Array
  #     return t.join(", ")
  #   else
  #     return t
  #   end
  # end

  # default_scope where(retired: false)

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
    if tx = Taxon.find_by_scientific_name(sn)
      self.taxon = tx
    end
  end

  def barcode_string
    barcode.barcode
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
        dictionary: "english",
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
      bc = Barcode.generate()
      self.barcode_string = bc.barcode
      self.barcode = bc
  end
end
