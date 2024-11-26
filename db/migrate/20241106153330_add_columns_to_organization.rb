class AddColumnsToOrganization < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :slack_workspace_token, :string
    add_column :organizations, :slack_channel, :string
  end
end
