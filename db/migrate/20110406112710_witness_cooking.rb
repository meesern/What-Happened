class WitnessCooking < ActiveRecord::Migration
  def self.up
    add_column :witnesses, :user_id, :integer
    remove_column :witnesses, :aspect_id

    remove_index :witnesses, :name => :index_witnesses_on_aspect_id rescue ActiveRecord::StatementInvalid
    add_index :witnesses, [:user_id]
  end

  def self.down
    remove_column :witnesses, :user_id
    add_column :witnesses, :aspect_id, :integer

    remove_index :witnesses, :name => :index_witnesses_on_user_id rescue ActiveRecord::StatementInvalid
    add_index :witnesses, [:aspect_id]
  end
end
