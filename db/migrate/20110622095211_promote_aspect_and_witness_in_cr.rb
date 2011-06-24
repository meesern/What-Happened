class PromoteAspectAndWitnessInCr < ActiveRecord::Migration
  def self.up
    remove_column :clerks_reports, :aspect
    remove_column :clerks_reports, :witness

    remove_column :reports, :made_by
    remove_column :reports, :known_until
  end

  def self.down
    add_column :clerks_reports, :aspect, :integer
    add_column :clerks_reports, :witness, :integer

    add_column :reports, :made_by, :integer
    add_column :reports, :known_until, :datetime
  end
end
