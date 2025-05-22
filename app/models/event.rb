class Event < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  validates :slug, presence: true
  validates :description, presence: true  
  validates :image_link, presence: true  
end
