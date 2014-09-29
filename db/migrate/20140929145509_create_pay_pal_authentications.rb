class CreatePayPalAuthentications < ActiveRecord::Migration
  def change
    create_table :pay_pal_authentications do |t|
      t.string :scope
      t.string :code

      t.timestamps
    end
  end
end
