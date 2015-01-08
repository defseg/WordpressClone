class Blog < ActiveRecord::Base

  validates :path, null: false, length: {maximum: 30}
  validates :title, null: false, length: {maximum: 255}
  validates :tagline, length: {maximum: 255, allow_nil: true}

  has_many :permissions, inverse_of: :blog
  has_many :staff, through: :permissions, source: :user
  has_many :posts

end