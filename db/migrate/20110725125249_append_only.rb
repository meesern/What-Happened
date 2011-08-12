class AppendOnly < ActiveRecord::Migration
  def self.up
    add_column :witnesses, :append_only, :boolean
  end

  def self.down
    remove_column :witnesses, :append_only
  end
end
