class CreateVisitlogs < ActiveRecord::Migration
  def self.up
    create_table :visitlogs do |t|
      t.integer :group_id
      t.integer :url_id
      t.string  :visitor, :limit => 40
      t.integer :visit_count, :default => 0
      t.float   :normalize_count, :default => 0.0
      t.float   :normalize_abs, :default => 0.0
      t.timestamps
    end

    add_index :visitlogs, [:group_id, :url_id, :visitor]
    add_index :visitlogs, [:group_id]
  end

  def self.down
    drop_table :visitlogs
  end
end
