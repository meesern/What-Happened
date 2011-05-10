class ConectClerksReport < ActiveRecord::Migration
  def self.up
    rename_column :reports, :known_from, :known
    add_column :reports, :clerks_report_id, :integer

    add_index :reports, [:clerks_report_id]
  end

  def self.down
    rename_column :reports, :known, :known_from
    remove_column :reports, :clerks_report_id

    remove_index :reports, :name => :index_reports_on_clerks_report_id rescue ActiveRecord::StatementInvalid
  end
end
