class Search < ActiveRecord::Base
  belongs_to :user
  has_many :matches

  validates :source_img_url, presence: true
end
