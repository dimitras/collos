# == Schema Information
#
# Table name: taxons
#
#  id              :integer          not null, primary key
#  ncbi_id         :integer          not null
#  scientific_name :string(255)
#  common_name     :string(255)
#

class Taxon < ActiveRecord::Base
  attr_accessible :ncbi_id,
    :scientific_name, :common_name
  has_many :samples
end
