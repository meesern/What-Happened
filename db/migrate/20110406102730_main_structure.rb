class MainStructure < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string   :name
      t.text     :description
      t.text     :pattern
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :user_id
    end
    add_index :items, [:user_id]

    create_table :witnesses do |t|
      t.string   :name
      t.text     :description
      t.text     :veracity
      t.text     :character
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :aspect_id
    end
    add_index :witnesses, [:aspect_id]

    create_table :aspects do |t|
      t.string   :name
      t.text     :description
      t.text     :pattern
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :entity_id
    end
    add_index :aspects, [:entity_id]

    create_table :reports do |t|
      t.datetime :known_from
      t.datetime :known_until
      t.text     :measurement
      t.float    :confidence
      t.integer  :made_by
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :aspect_id
    end
    add_index :reports, [:aspect_id]

    create_table :properties do |t|
      t.text     :box
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :entity_id
      t.integer  :item_id
    end
    add_index :properties, [:entity_id]
    add_index :properties, [:item_id]

    add_column :entities, :item_id, :integer

    add_index :entities, [:item_id]
  end

  def self.down
    remove_column :entities, :item_id

    drop_table :items
    drop_table :witnesses
    drop_table :aspects
    drop_table :reports
    drop_table :properties

    remove_index :entities, :name => :index_entities_on_item_id rescue ActiveRecord::StatementInvalid
  end
end
