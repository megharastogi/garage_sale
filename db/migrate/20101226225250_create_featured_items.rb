class CreateFeaturedItems < ActiveRecord::Migration
  def self.up
    create_table :featured_items do |t|
      t.string :name
      t.text :description
      t.integer :bidding
      t.integer :price
      t.integer :sale_id
      t.string :sample_file_name
      t.string :sample_content_type
      t.timestamps
    end
  end

  def self.down
    drop_table :featured_items
  end
end

