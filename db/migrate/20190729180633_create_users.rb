class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :weight 
      t.date :birthdate
      t.string :gender
      t.string :password
    end
  end


end
