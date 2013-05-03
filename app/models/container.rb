# == Schema Information
#
# Table name: containers
#
#  id                :integer          not null, primary key
#  barcode_id        :integer
#  container_type_id :integer
#  ancestry          :string(255)      not null
#  ancestry_depth    :integer          default(0)
#  x                 :integer          default(0)
#  y                 :integer          default(0)
#  retired           :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Container < ActiveRecord::Base
    belongs_to :barcode
    belongs_to :container_type
    has_many :samples

    attr_accessible :ancestry, :barcode, :x, :y, :retired

    # Barcodes should be mandatory and unique
    validates :barcode, presence: true
    # validates :barcode, unique: true

    # Sets the default scope to only find containers that are active.
    # To find all entries, use "Container.unscoped.find" or some derivative.
    default_scope where(retired: false)

    has_ancestry :orphan_strategy => :rootify, :cache_depth => true

end
