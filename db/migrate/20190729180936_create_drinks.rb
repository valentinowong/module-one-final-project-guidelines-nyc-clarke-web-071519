class CreateDrinks < ActiveRecord::Migration[5.0]
  def change
    create_table :drinks do |t|
    t.string :name
    t.text :description
    t.float :alcohol_percentage
    end
  end
end
