class AddAspect < ActiveRecord::Migration
  def self.up
    rename_column :replays, :until, :to
    add_column :replays, :aspect_id, :integer

    add_index :replays, [:aspect_id]
  end

  def self.down
    rename_column :replays, :to, :until
    remove_column :replays, :aspect_id

    remove_index :replays, :name => :index_replays_on_aspect_id rescue ActiveRecord::StatementInvalid
  end
end
