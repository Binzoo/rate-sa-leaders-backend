class Politician < ApplicationRecord
  has_many :votes, dependent: :destroy
end
