class AddDefaultToSecond < ActiveRecord::Migration
  def self.up
    change_column :reports, :second, :float, :default => 0.0
  end

  def self.down
    change_column :reports, :second, :float
  end
end
