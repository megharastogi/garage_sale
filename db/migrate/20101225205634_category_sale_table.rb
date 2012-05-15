class CategorySaleTable < ActiveRecord::Migration
  def self.up
    create_table :categories_sales, :id => false do |t|
      t.integer :category_id
      t.integer :sale_id
    end
  end

  def self.down
    drop_table :categories_sales
  end
end
