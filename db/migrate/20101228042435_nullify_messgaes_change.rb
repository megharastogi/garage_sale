class NullifyMessgaesChange < ActiveRecord::Migration
  def self.up
        add_column :messages , :category , :string
    remove_column :messages,:user_id
    remove_column :messages,:sale_id
  end

  def self.down
      add_column :messages , :user_id , :integer
    add_column :messages , :sale_id , :integer
    remove_column :messages,:category

  end
end

