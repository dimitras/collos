# == Schema Information
#
# Table name: studies
#
#  id               :integer          not null, primary key
#  title            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  identifier       :string(255)
#  description      :text
#  investigation_id :integer
#  tsv_content      :tsvector
#

class Study < ActiveRecord::Base
	attr_accessible :title, :identifier, :description, :investigation_id, :investigation_title, :investigation

	belongs_to :investigation, :inverse_of => :studies
	has_and_belongs_to_many :samples#, foreign_key: "id"
	has_and_belongs_to_many :people

	#accepts_nested_attributes_for :samples, :reject_if => lambda{|a| a[:name].blank?}, :allow_destroy => true 

	validates_presence_of :investigation

	def investigation_title
		investigation.try(:title)
	end

	def samples_for_csv
		label_attrs = ["sample_collos_id", "sample_identifier", "id_barcode", "id_subject", "id_study", "sample_type", "collection-time-point", "treatment", "sample_name", "species","material_type", "quantity", "box_label", "box_barcode", "freezer_label", "freezer_type", "type"]
		CSV.generate do |csv|
			csv<< label_attrs
			containers = []
			samples.each do |sample|
				if !sample.retired
					csv << [sample.id, sample.name, sample.barcode_string, sample.source_name, identifier, sample.tissue_type_name, sample.time_point, sample.treatments, sample.replicate, sample.scientific_name, sample.material_type_name, sample.quantity, sample.container.parent.name, sample.container.parent.barcode_string, sample.container.parent.parent.name, sample.container.parent.parent.container_type_name, "sample"]
					containers << sample.container.parent
				end
			end
			containers.uniq.each do |container|
				csv << [container.id, container.name, container.barcode, "", identifier, container.container_type_name, "","","", "", "", "","","", "container"]
			end
		end
	end
	
	# Full text search of samples
	include PgSearch
	multisearchable against: [:title, :identifier, :description],
	using: {
		tsearch: {
			dictionary: "english",
			any_word: true,
			prefix: true,
			tsvector_column: 'tsv_content'
		}
	}

	pg_search_scope :search, against: [:title, :identifier, :description],
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
