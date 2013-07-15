# == Schema Information
#
# Table name: ontologies
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :string(255)
#  uri         :string(255)      not null
#  prefix      :string(255)      not null
#

class Ontology < ActiveRecord::Base
  attr_accessible :name, :description, :prefix, :uri, :release
  validates :name, presence: true
  validates :prefix, presence: true
  validates :uri, presence: true
  has_many :ontology_terms
end
