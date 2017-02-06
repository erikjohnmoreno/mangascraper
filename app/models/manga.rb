class Manga < ApplicationRecord
  belongs_to :user
  has_many :chapters
end
