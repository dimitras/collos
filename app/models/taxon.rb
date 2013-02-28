class Taxon < ActiveRecord::Base
  attr_accessible :ancestry, :ancestry_depth, :ncbi_id, :parent_ncbi_id, :rank
  has_ancestry :orphan_strategy => :rootify, :cache_depth => true
end
