# == Schema Information
#
# Table name: taxons
#
#  id             :integer          not null, primary key
#  ncbi_id        :integer
#  parent_ncbi_id :integer
#  rank           :string(255)
#  ancestry       :string(255)
#  ancestry_depth :integer          default(0)
#

class Taxon < ActiveRecord::Base
  attr_accessible :ancestry, :ancestry_depth, :ncbi_id, :parent_ncbi_id, :rank

  has_many :samples
  has_many :taxon_names


  has_ancestry :orphan_strategy => :rootify, :cache_depth => true
end
