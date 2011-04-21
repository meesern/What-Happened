class MoreWitnessCooking < ActiveRecord::Migration
  def self.up
    add_column :witnesses, :aspect_id, :integer

    add_index :witnesses, [:aspect_id]
  end

  def self.down
    remove_column :witnesses, :aspect_id

    remove_index :witnesses, :name => :index_witnesses_on_aspect_id rescue ActiveRecord::StatementInvalid
  end
end
