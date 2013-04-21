class CreateSimilarities < ActiveRecord::Migration
  def self.up
    create_table :similarities do |t|
      t.integer :group_id
      t.string  :visitor,        :limit => 40
      t.string  :target_visitor, :limit => 40
      t.float   :similar_ratio
      t.timestamps
    end

    add_index :similarities, [:group_id, :visitor, :target_visitor]
  end

  def self.down
    drop_table :similarities
  end
end
