class CreateElements < ActiveRecord::Migration[5.1]
  def change
    create_table :vertices do |t|
      t.integer :max_hops_to_end
    end

    create_table :edges do |t|
      t.integer :to_id, index: true
      t.integer :from_id, index: true
      t.boolean :in_longest_path, required: true
    end

    #This will prevent duplicated edges at the db level.
    add_index :edges, [:to_id, :from_id], unique: true
  end
end
