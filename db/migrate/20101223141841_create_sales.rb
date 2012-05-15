class CreateSales < ActiveRecord::Migration
  def self.up
    create_table :sales do |t|
      t.date :start_date
      t.date :end_date
      t.string :name
      t.integer :city_id
      t.integer :state_id
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :sales
  end
end
