class AddReportToReplay < ActiveRecord::Migration
  def self.up
    add_column :replays, :report_id, :integer

    add_index :replays, [:report_id]
  end

  def self.down
    remove_column :replays, :report_id

    remove_index :replays, :name => :index_replays_on_report_id rescue ActiveRecord::StatementInvalid
  end
end
