class AddEmailAndAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    add_column :users, :address, :text
  end
end
