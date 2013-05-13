# == Schema Information
#
# Table name: containers
#
#  id                :integer          not null, primary key
#  container_type_id :integer
#  name              :string(255)
#  ancestry          :string(255)      not null
#  ancestry_depth    :integer          default(0)
#  x                 :integer          default(0)
#  y                 :integer          default(0)
#  retired           :boolean          default(FALSE)
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Container < ActiveRecord::Base
    belongs_to :container_type
    has_many :samples
    has_one :barcode, as: :barcodeable

    attr_accessible :name, :notes, :ancestry, :x, :y, :retired, :barcode

    # Barcodes should be mandatory and unique
    # validates :barcode, presence: true
    # validates :barcode, unique: true

    # Sets the default scope to only find containers that are active.
    # To find all entries, use "Container.unscoped.find" or some derivative.
    default_scope where(retired: false)

    has_ancestry :orphan_strategy => :rootify, :cache_depth => true
    has_paper_trail

end
