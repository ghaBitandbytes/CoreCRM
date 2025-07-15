class Stage < ApplicationRecord
    has_many :deals
    default_scope { order(:position) }
end
