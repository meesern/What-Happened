class AddClerksReport < ActiveRecord::Migration
  def self.up
    create_table :clerks_reports do |t|
      t.integer  :witness
      t.integer  :aspect
      t.decimal  :submitted_records
      t.decimal  :accepted_records
      t.text     :status
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :witnesses, :api_key, :string
  end

  def self.down
    remove_column :witnesses, :api_key

    drop_table :clerks_reports
  end
end
