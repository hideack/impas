class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.string :url
      t.string :urlhash, :limit => 40
      t.integer :tw, :default => 0
      t.integer :fb, :default => 0
      t.integer :hatena, :default => 0
      t.boolean :lock, :default => false
      t.timestamps
    end
    
    add_index :urls, :urlhash
  end

  def self.down
    drop_table :urls
  end
end
