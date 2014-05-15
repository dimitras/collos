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
#

class Sample < ActiveRecord::Base
  attr_accessible :name, :barcode, :external_identifier,
    :taxon, :taxon_id, :scientific_name, :common_name,
    :container, :container_id, :container_x, :container_y,
    :protocol_application, :protocol_application_id,
    :notes, :retired, :tags, :sex, :sex_id, :source_name,
    :ancestry, :parent_id, :parent,
    :material_type_ids, :material_type_id,
    :study_titles, :study_ids, :study_id, 
    :age_id, :age, :time_point

  validates :age, :inclusion => 0..1000

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
  # belongs_to_many :protocol_applications
  has_and_belongs_to_many :material_types, :order => "LOWER(name)"
  belongs_to :taxon
  belongs_to :sex, class_name: "OntologyTerm", foreign_key: "sex_id"
  belongs_to :timeunit, class_name: "OntologyTerm", foreign_key: "age_id"
  has_and_belongs_to_many :studies, :order => "LOWER(title)"
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

  def study_titles
    titles=[]
    studies.each do |study|
      titles << study.try(:title)
    end
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

  # Full text search of samples
  include PgSearch
  multisearchable against: [:name, :barcode_string, :tags, :notes, :source_name, :external_identifier, :age, :time_point, :sex, :timeunit],
    using: {
      tsearch: {
        dictionary: "english",
        any_word: true,
        prefix: true,
        tsvector_column: 'tsv_content'
      }
    }

  pg_search_scope :search, against: [:name, :barcode_string, :tags, :notes, :source_name, :external_identifier, :age, :time_point, :sex, :timeunit],
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
