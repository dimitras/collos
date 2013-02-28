class Ontology < ActiveRecord::Base
  attr_accessible :name, :description, :prefix, :uri
  validates :name, presence: true, on: :create, message: "can't be blank"
  validates :prefix, presence: true,  :on => :create, :message => "can't be blank"
  validates :uri, presence: true, :on => :create, :message => "can't be blank"
end
