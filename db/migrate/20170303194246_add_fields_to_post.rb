class AddFieldsToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :listingtype, :string
    add_column :posts, :address, :string
    add_column :posts, :source_account, :string
  end
end
