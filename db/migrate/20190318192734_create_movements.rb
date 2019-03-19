class CreateMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :movements do |t|
      t.references :account, foreign_key: true
      t.decimal :amount
      t.string :reference

      t.timestamps
    end
  end
end
