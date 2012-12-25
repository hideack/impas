class CreateCrawlelists < ActiveRecord::Migration
  def self.up
    create_table :crawlelists do |t|
      t.integer :userid
      t.integer :urlid
      t.integer :groupid
      t.integer :callcount
      t.timestamps
    end
  end

  def self.down
    drop_table :crawlelists
  end
end
