class CreateReplays < ActiveRecord::Migration
  def self.up
    create_table :replays do |t|
      t.text :name
      t.decimal :rate
      t.decimal :gapskip
      t.datetime :from
      t.datetime :until
      t.boolean :running
      t.datetime :playtime

      t.timestamps
    end
  end

  def self.down
    drop_table :replays
  end
end
