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
#  source_name             :string(255)
#  study_id                :integer
#  ancestry                :string(500)
#  ancestry_depth          :integer          default(0)
#  sex_id                  :integer
#  material_type_id        :integer
#  external_identifier     :string(255)
#  age                     :integer
#  time_point              :string(255)
#  age_id                  :integer
#  strain_id               :integer
#  tissue_type_id          :integer
#  primary_cell_id         :integer
#  treatments              :string(255)
#  genotype                :string(255)
#  replicate               :string(255)
#  protocols               :string(255)
#  race_id                 :integer
#  ethnicity_id            :integer
#

class Sample < ActiveRecord::Base
  attr_accessible :name, :barcode, :external_identifier,
    :taxon, :taxon_id, :scientific_name, :common_name,
    :container, :container_id, :container_x, :container_y,
    :protocol_application, :protocol_application_id,
    :notes, :retired, :tags,
    :ancestry, :parent_id, :parent,
    :study_titles, :studies, :study_id, :study_ids,
    #TOFIX: study ids?!?!?!
    :time_point, :genotype, :treatments, :replicate, :source_name,
    :material_type, :material_type_id, :tissue_type, :tissue_type_id, :primary_cell, :primary_cell_id,
    :strain, :strain_id, :timeunit, :age, :age_id, :sex, :sex_id, :race, :race_id, :ethnicity, :ethnicity_id,
    :protocols

  validates :age, :inclusion => 0..1000, :allow_nil => true
  #validates :tissue_type, length: { maximum: 25 }
  #validates :material_type, length: { maximum: 25 }
  #validates :primary_cell, length: { maximum: 25 }
  #validates :treatments, length: { maximum: 25 }
  #validates :name, length: { maximum: 25 }
  
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
  belongs_to :taxon
  belongs_to :sex, class_name: "OntologyTerm", foreign_key: "sex_id"
  belongs_to :strain, class_name: "OntologyTerm", foreign_key: "strain_id"
  belongs_to :race
  belongs_to :ethnicity
  belongs_to :material_type, class_name: "OntologyTerm", foreign_key: "material_type_id"
  belongs_to :tissue_type, class_name: "OntologyTerm", foreign_key: "tissue_type_id"
  belongs_to :primary_cell, class_name: "OntologyTerm", foreign_key: "primary_cell_id"
  belongs_to :timeunit, class_name: "OntologyTerm", foreign_key: "age_id"
  has_and_belongs_to_many :studies, :order => "LOWER(title)"
  has_many :external_links
  # belongs_to_many :protocol_applications
  # has_and_belongs_to_many :material_types, :order => "LOWER(name)"
  # has_many :container_types, :through => :container

  # parent-child-sibling relationships
  has_ancestry :orphan_strategy => :rootify, :cache_depth => true

  alias_method :sample, :parent

  # TODO: for the number of children to be created
  # scope :number_of_children, lambda { |count|
  #   {
  #     :conditions => ["COUNT(sample.children.count) == ?", count]
  #   }
  # }
  # accepts_nested_attributes_for :children, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

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

  def race_name
    race.try(:name)
  end

  def ethnicity_name
    ethnicity.try(:name)
  end

  def material_type_name
    material_type.try(:name)
  end

  def tissue_type_name
    tissue_type.try(:name)
  end

  def study_titles
    titles=[]
    studies.each do |study|
      titles << study.try(:title)
    end
    return titles
  end

  # def container_name
  #   Container.find_by_id(:container_id).name
  # end
  # def tubes
  #   tubes = []
  #   if container.container_type_id == 3
  #     tubes.push(container_name)
  #   end
  # end
  # def boxes
  #   boxes = []
  #   if container.container_type_id == 5
  #     boxes.push(container_name)
  #   end
  # end

  def barcode_string
    barcode.barcode
  end

  def label_fields
    return [name, barcode_string, study_id, source_name, treatments, time_point]
  end

  # Sample hierarchy is represented (loosely) as a directed acyclic graph.
  # This is not strictly correct, but serves better for our purposes than a
  # strict tree hiearchy.
  has_dag_links link_class_name: 'SampleRelationship'

  before_create :assign_barcode
  def assign_barcode
      bc = Barcode.generate()
      self.barcode_string = bc.barcode
      self.barcode = bc
  end

  def self.gender_type_terms
    OntologyTerm.where(
      name: "biological sex",
      accession: "obo:PATO_0000047"
    ).first.children()
  end

  def self.time_type_terms
    OntologyTerm.where(
      name: "time unit",
      accession: "UO:0000003"
    ).first.children()
  end

  def self.strain_type_terms
    OntologyTerm.where(
      name: "strain",
      accession: "EFO_0005135"
    ).first.children()
  end

  def self.material_type_terms
    OntologyTerm.where(
      name: "material type",
      accession: "EFO_0001434"
    ).first.children()
  end

  def self.tissue_type_terms
    OntologyTerm.where(
      name: "tissue type",
      accession: "BTO:0000000"
    ).first.children()
  end

  def self.primary_cell_type_terms
    OntologyTerm.where(
      name: "primary cell / cell line / tissue type",
      accession: "EFO_primary_cell_line"
    ).first.children()
  end

  # Full text search of samples
  include PgSearch
  multisearchable against: [:name, :barcode_string, :tags, :notes, :source_name, :external_identifier, :age, :time_point, :sex, :timeunit, :material_type, :treatments, :tissue_type, :primary_cell, :strain, :genotype, :protocols],
    using: {
      tsearch: {
        dictionary: "english",
        any_word: true,
        prefix: true,
        tsvector_column: 'tsv_content'
      }
    }

  pg_search_scope :search, against: [:name, :barcode_string, :tags, :notes, :source_name, :external_identifier, :age, :time_point, :sex, :timeunit, :material_type, :treatments, :tissue_type, :primary_cell, :strain, :genotype, :protocols],
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
