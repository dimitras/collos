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
  attr_accessible :name, :description, :prefix, :uri
  validates :name, presence: true, on: :create
  validates :prefix, presence: true,  :on => :create
  validates :uri, presence: true, :on => :create

  has_many :ontology_terms
end
