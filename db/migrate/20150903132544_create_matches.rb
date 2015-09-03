class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :img_direct_url, null: false
      t.string :img_host_url, null: false
      t.integer :search_id, null: false

      t.timestamps null: false
    end
  end
end
