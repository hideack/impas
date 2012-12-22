class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.string :url
      t.string :urlhash, :limit => 40
      t.integer :tw
      t.integer :fb
      t.integer :hatena
      t.boolean :lock
      t.timestamps
    end
  end

  def self.down
    drop_table :urls
  end
end
