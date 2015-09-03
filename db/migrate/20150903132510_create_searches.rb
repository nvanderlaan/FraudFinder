class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :title
      t.string :description
      t.string :source_img_url, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
