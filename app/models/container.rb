class Container < ActiveRecord::Base
  belongs_to :container_type
  
  attr_accessible :ancestry, :barcode, :x, :y, :retired

  # Barcodes should be mandatory and unique
  validates :barcode, presence: true
  # validates :barcode, unique: true

  # Sets the default scope to only find containers that are active.
  # To find all entries, use "Container.unscoped.find" or some derivative.
  default_scope where(retired: false)

  has_ancestry :orphan_strategy => :rootify, :cache_depth => true

end
