class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :heading
      t.text :body
      t.decimal :price
      t.string :city
      t.string :external_url
      t.string :timestamp

      t.timestamps
    end
  end
end
