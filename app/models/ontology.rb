class Ontology < ActiveRecord::Base
  attr_accessible :name, :description, :prefix, :uri
  validates :name, presence: true, on: :create
  validates :prefix, presence: true,  :on => :create
  validates :uri, presence: true, :on => :create
end
