class AddPlayhead < ActiveRecord::Migration
  def self.up
    add_column :replays, :playhead, :datetime
  end

  def self.down
    remove_column :replays, :playhead
  end
end
