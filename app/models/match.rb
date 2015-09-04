class Match < ActiveRecord::Base
  belongs_to :search

  validates :img_direct_url, presence: true
  validates :img_host_url, presence: true

  def self.process_matches(result_hash)
    new_hash = {}
    result_hash.each do |key, value|
        value.each do |key, value|
          value.each do |key, value|
            if value
              new_hash[value["page"]] = value["usage-image"]
            end
          end
      end
    end
    new_hash
  end

  # match1 = @search.matches.create!(link_to_site: @new_hash.keys[0], img_url: @new_hash.values[0])
  # match2 = @search.matches.create!(link_to_site: @new_hash.keys[1], img_url: @new_hash.values[1])
  # match3 = @search.matches.create!(link_to_site: @new_hash.keys[2], img_url: @new_hash.values[2])
  # match4 = @search.matches.create!(link_to_site: @new_hash.keys[3], img_url: @new_hash.values[3])
  # match5 = @search.matches.create!(link_to_site: @new_hash.keys[4], img_url: @new_hash.values[4])

end
