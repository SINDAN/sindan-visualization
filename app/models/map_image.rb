class MapImage < ApplicationRecord
  validates_uniqueness_of :name, allow_blank: true

  default_scope { order(name: :asc) }
end
