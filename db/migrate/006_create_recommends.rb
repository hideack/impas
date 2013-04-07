class CreateRecommends < ActiveRecord::Migration
  def self.up
    create_table :recommends do |t|
      t.integer :group_id
      t.string  :visitor, :limit => 40
      t.integer :url_id
      t.float   :recommended_ratio
      t.timestamps
    end

    add_index :recommends, [:group_id, :visitor, :recommended_ratio]
  end

  def self.down
    drop_table :recommends
  end
end
