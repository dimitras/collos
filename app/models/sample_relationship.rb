# == Schema Information
#
# Table name: sample_relationships
#
#  id            :integer          not null, primary key
#  ancestor_id   :integer
#  descendant_id :integer
#  direct        :boolean
#  count         :integer
#

class SampleRelationship < ActiveRecord::Base
  attr_accessible :ancestry, :ancestor_id, :count, :descendant, :descendant_id, :direct
  acts_as_dag_links node_class_name: "Sample"

end
