class Sample < ActiveRecord::Base
  belongs_to :container
  belongs_to :protocol_application

  attr_accessible :name

  validates :name, presence: true

  has_ancestry :orphan_strategy => :rootify, :cache_depth => true

end
