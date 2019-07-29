class CreateUserDrinks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_drinks do |t|
    t.datetime :datetime 
    t.integer :amount
    t.integer :drink_id
    t.integer :user_id
    end
  end
end
