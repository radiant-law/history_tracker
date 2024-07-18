class CreateAuditHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :audit_histories do |t|
      t.references :belonging, polymorphic: true
      t.references :historyable, polymorphic: true
      t.string :action
      t.text :original
      t.text :modified
      t.text :changeset
      t.integer :modifier_id

      t.timestamps
    end
  end
end
