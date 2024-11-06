class AddColumnsToLeads < ActiveRecord::Migration[7.2]
  def change
    add_reference :leads, :company, null: true, foreign_key: true
    add_reference :leads, :person, null: true, foreign_key: true
    add_reference :leads, :stage, null: false, foreign_key: true
    add_column :leads, :description, :text
  end
end
