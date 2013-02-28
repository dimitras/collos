class Protocol < ActiveRecord::Base
  attr_accessible :accession, :description, :name, :uri
end
