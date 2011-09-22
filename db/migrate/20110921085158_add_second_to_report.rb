class AddSecondToReport < ActiveRecord::Migration
  def self.up
    add_column :reports, :second, :float
  end

  def self.down
    remove_column :reports, :second
  end
end
