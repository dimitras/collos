# == Schema Information
#
# Table name: taxons
#
#  id              :integer          not null, primary key
#  ncbi_id         :integer          not null
#  scientific_name :string(255)
#  common_name     :string(255)
#  tsv_content     :tsvector
#

class Taxon < ActiveRecord::Base
  attr_accessible :ncbi_id, :scientific_name, :common_name
  has_many :samples

  # Full text search of samples
  include PgSearch
  multisearchable against: [:ncbi_id, :scientific_name, :common_name],
  using: {
    tsearch: {
      dictionary: "english",
      any_word: true,
      prefix: true,
      tsvector_column: 'tsv_content'
    }
  }

  pg_search_scope :search, against: [:ncbi_id, :scientific_name, :common_name],
  using: {
    tsearch: {
      dictionary: "english",
      any_word: true,
      prefix: true,
      tsvector_column: 'tsv_content'
    }
  }
end
