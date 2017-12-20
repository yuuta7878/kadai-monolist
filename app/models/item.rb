class Item < ApplicationRecord
  # バリデーション
  validates :code, presence: true, length: { maximum: 255 }
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, presence: true, length: { maximum: 255 }
  validates :image_url, presence: true, length: { maximum: 255 }
  has_many :wants
  has_many :want_users, through: :wants, class_name: 'User', source: :user
  has_many :haves
  has_many :have_users, through: :haves, class_name: 'User', source: :user
end
