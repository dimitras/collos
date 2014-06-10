# == Schema Information
#
# Table name: races
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Race < ActiveRecord::Base
  attr_accessible :name

  has_many :samples

  # Full text search of race
  include PgSearch
  multisearchable against: [:name],
  using: {
    tsearch: {
      dictionary: "english",
      any_word: true,
      prefix: true,
      tsvector_column: 'tsv_content'
    }
  }

  pg_search_scope :search, against: [:name],
  using: {
    tsearch: {
      dictionary: "english",
      any_word: true,
      prefix: true,
      tsvector_column: 'tsv_content'
    }
  }
end
