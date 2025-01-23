class AddSlugToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :slug, :string

    # Ensure that slugs are unique for existing records
    reversible do |dir|
      dir.up do
        Organization.reset_column_information

        Organization.find_each do |organization|
          next if organization.slug.present?

          organization.update_columns(slug: organization.name.parameterize)
        end
      end
    end

    add_index :organizations, :slug, unique: true
    change_column_null :organizations, :slug, false
  end
end
