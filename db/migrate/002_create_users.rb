class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :limit => 64
      t.string :key,  :limit => 40
      t.integer :type, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
