class Match < ActiveRecord::Base
  belongs_to :search

  validates :img_direct_url, presence: true
  validates :img_host_url, presence: true
end
