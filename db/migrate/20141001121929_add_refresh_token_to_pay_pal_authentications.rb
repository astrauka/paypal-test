class AddRefreshTokenToPayPalAuthentications < ActiveRecord::Migration
  def change
    add_column :pay_pal_authentications, :refresh_token, :string
  end
end
