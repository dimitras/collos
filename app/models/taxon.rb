# == Schema Information
#
# Table name: taxons
#
#  id             :integer          not null, primary key
#  ncbi_id        :integer
#  parent_ncbi_id :integer
#  rank           :string(255)
#  ancestry       :string(255)
#  ancestry_depth :integer
#

class Taxon < ActiveRecord::Base
  attr_accessible :ancestry, :ancestry_depth, :ncbi_id, :parent_ncbi_id, :rank
  has_ancestry :orphan_strategy => :rootify, :cache_depth => true
end
