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
#

class Container < ActiveRecord::Base
    attr_accessible :name,  :barcode,
        :ancestry, :container_x, :container_y,
        :container_type_name, :container_type, :container_type_id,
        :retired, :tags, :notes

    belongs_to :container_type, inverse_of: :containers
    has_many :samples
    has_one :barcode, as: :barcodeable
    has_and_belongs_to_many :shipments

    # parent-child-sibling relationships
    has_ancestry :orphan_strategy => :rootify, :cache_depth => true

    # version information
    has_paper_trail

    validates_presence_of :container_type


    # some handy methods
    alias_method :container, :parent
    def container_type_name
        container_type.name
    end

    def to_s
        "[#{barcode.barcode}] #{name} (#{container_type.name})"
    end

    def show_location?
        container_type.x_dimension * container_type.y_dimension > 1
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
    private
    def assign_barcode
        bc = Barcode.generate()
        self.barcode_string = bc.barcode
        self.barcode = bc
    end

end
