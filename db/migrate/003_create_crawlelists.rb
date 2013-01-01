class CreateCrawlelists < ActiveRecord::Migration
  def self.up
    create_table :crawlelists do |t|
      t.integer :user_id
      t.integer :url_id
      t.integer :group_id
      t.integer :callcount
      t.timestamps
    end

    add_index :crawlelists, [:user_id, :url_id, :group_id]
  end

  def self.down
    drop_table :crawlelists
  end
end
