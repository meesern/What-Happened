class FixClerksReportAssociations < ActiveRecord::Migration
  def self.up
    remove_column :witnesses, :aspect_id

    add_column :clerks_reports, :aspect_id, :integer
    add_column :clerks_reports, :witness_id, :integer

    remove_index :witnesses, :name => :index_witnesses_on_aspect_id rescue ActiveRecord::StatementInvalid

    add_index :clerks_reports, [:aspect_id]
    add_index :clerks_reports, [:witness_id]
  end

  def self.down
    add_column :witnesses, :aspect_id, :integer

    remove_column :clerks_reports, :aspect_id
    remove_column :clerks_reports, :witness_id

    add_index :witnesses, [:aspect_id]

    remove_index :clerks_reports, :name => :index_clerks_reports_on_aspect_id rescue ActiveRecord::StatementInvalid
    remove_index :clerks_reports, :name => :index_clerks_reports_on_witness_id rescue ActiveRecord::StatementInvalid
  end
end
