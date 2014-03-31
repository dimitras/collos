# == Schema Information
#
# Table name: containers
#
#  id                :integer          not null, primary key
#  container_type_id :integer
#  name              :string(255)
#  barcode_string    :string(255)
#  ancestry          :string(500)
#  ancestry_depth    :integer          default(0)
#  container_x       :integer          default(0)
#  container_y       :integer          default(0)
#  retired           :boolean          default(FALSE)
#  tags              :string(500)
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  tsv_content       :tsvector
#  shipped           :boolean
#

class Container < ActiveRecord::Base
    attr_accessible :name, :barcode,
        :ancestry, :container_x, :container_y,
        :container_type_name, :container_type, :container_type_id,
        :retired, :tags, :notes, :parent_id, :shipped, :parent

    belongs_to :container_type, inverse_of: :containers
    has_many :samples
    has_one :barcode, as: :barcodeable
    has_and_belongs_to_many :shipments

    # parent-child-sibling relationships
    has_ancestry :orphan_strategy => :rootify, :cache_depth => true

    validates_presence_of :container_type
    
    # some handy methods
    alias_method :container, :parent
    
    scope :non_retired, where(:retired => false)
    scope :with_children, ->() {
        joins(:container_type).where(container_types: {can_have_children: true})
    }
    scope :non_tube, ->() {
        # joins(:container_type).where('container_types.type' => 'test tube')
        joins(:container_type).where(container_types: {name: "1.5 mL tube"})
        # joins(:container_type).where(container_types: {"test tube" not in (?) :type})
    }
    #scope :not_in_use, where(samples_count = 0)

    # def not_in_use
    #     samples if samples.count == 0
    # end

	def container_type_name
        container_type.name
    end

    def to_s
        "[#{barcode.barcode}] #{name} (#{container_type_name})"
    end

    def show_location?
        container_type.x_dimension * container_type.y_dimension > 1
    end

	def self.arrange_as_array(options={}, hash=nil)
        hash ||= arrange(options)

		arr = []
		hash.each do |node, children|
			arr << node
			arr += arrange_as_array(options, children) unless children.nil?
		end
		arr
	end

	def name_for_selects
		# "#{'-' * depth} #{name}"
        "[#{barcode}] #{name} (#{container_type_name})"
	end

	def possible_parents
		parents = Container.arrange_as_array(:order => 'name')
		return new_record? ? parents : parents - subtree
	end
	
    # Collects the associated samples or child containers into a
    # 2D Array sparse matrix
    def container_matrix
        cm = Array.new(container_type.y_dimension, Array.new(container_type.x_dimension, nil))
        children.each  do |c|
            cm[c.container_y][c.container_x] = container_x
        end
        samples.each do |s|
            cm[s.container_y][container_x] = s
        end
        return cm
    end

    before_create :assign_barcode
    def assign_barcode
        bc = Barcode.generate()
        self.barcode_string = bc.barcode
        self.barcode = bc
    end

    # Full text search of containers
    include PgSearch
    multisearchable against: [:name, :barcode_string, :tags, :notes],
        using: {
            tsearch: {
                dictionary: "english",
                any_word: true,
                prefix: true,
                tsvector_column: 'tsv_content'
            }
        }
      pg_search_scope :search, against:  [:name, :barcode_string, :tags, :notes],
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
