class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :CLABE
      t.references :user, foreign_key: true

      t.timestamps

      t.index :CLABE
    end
  end
end
