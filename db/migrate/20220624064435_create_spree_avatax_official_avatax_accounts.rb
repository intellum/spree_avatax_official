class CreateSpreeAvataxOfficialAvataxAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_avatax_official_avatax_accounts do |t|
      t.integer :account_id, null: false
      t.integer :spree_store_id, null: false
      t.boolean :enabled, default: false
      t.string  :company_code
      t.string  :account_number
      t.string  :license_key
      t.timestamps
    end
  end
end