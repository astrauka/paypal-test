class AddUserIdToPayPalAuthentication < ActiveRecord::Migration
  def change
    add_reference :pay_pal_authentications, :user, index: true
  end
end
