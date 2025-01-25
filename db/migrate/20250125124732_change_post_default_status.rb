class ChangePostDefaultStatus < ActiveRecord::Migration[7.2]
  def change
    change_column_default :posts, :status, "draft"
  end
end
