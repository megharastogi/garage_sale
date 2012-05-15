class CreateSaleViews < ActiveRecord::Migration
  def self.up
    create_table :sale_views do |t|
      t.integer :sale_id
      t.string :ip

      t.timestamps
    end
  end

  def self.down
    drop_table :sale_views
  end
end
