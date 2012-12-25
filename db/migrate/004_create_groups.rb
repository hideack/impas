class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.integer :userid
      t.string :key,  :limit => 40
      t.string :name, :limit => 128
      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
