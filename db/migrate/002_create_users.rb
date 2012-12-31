class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :limit => 64
      t.string :opkey,  :limit => 40
      t.integer :usertype, :default => 0
      t.timestamps
    end

    add_index :users, :opkey
  end

  def self.down
    drop_table :users
  end
end
