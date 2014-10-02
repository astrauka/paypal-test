class User < ActiveRecord::Base
  serialize :address, Hash

  has_one :pay_pal_authentication
end
