class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.integer :user_id
      t.string :key,  :limit => 40
      t.string :name, :limit => 128
      t.timestamps
    end

    add_index :groups, :key
  end

  def self.down
    drop_table :groups
  end
end
