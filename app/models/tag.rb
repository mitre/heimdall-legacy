class Tag < ApplicationRecord
  store :content_hash, accessors: [:name, :value], coder: JSON
  belongs_to :tagger, polymorphic: true

  def self.options_for_select
    options = []
    Constants::TAG_NAMES.each do |val|
      options << [val, val.downcase]
    end
    options
  end
end
