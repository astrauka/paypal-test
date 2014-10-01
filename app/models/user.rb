class User < ActiveRecord::Base
  has_one :pay_pal_authentication
end
