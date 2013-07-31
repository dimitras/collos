# == Schema Information
#
# Table name: containers
#
#  id                :integer          not null, primary key
#  container_type_id :integer
#  name              :string(255)
#  ancestry          :string(500)
#  ancestry_depth    :integer          default(0)
#  parent_x          :integer          default(0)
#  parent_y          :integer          default(0)
#  retired           :boolean          default(FALSE)
#  tags              :string(500)
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
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

    before_create :assign_barcode
    def assign_barcode
        self.barcode ||= Barcode.generate()
    end

    def container_type_name
        container_type.name
    end

    def container_type_name=(cname)
        self.container_type = ContainerType.from_pretty_string(cname)
    end

    def to_s
        "[#{barcode.barcode}] #{name} (#{container_type.name})"
    end

    def show_location?
        container_type.x_dimension * container_type.y_dimension > 1
    end
end
