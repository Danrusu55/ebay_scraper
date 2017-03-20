class CreateAnchors < ActiveRecord::Migration[5.0]
  def change
    create_table :anchors do |t|
      t.string :value

      t.timestamps
    end
  end
end
