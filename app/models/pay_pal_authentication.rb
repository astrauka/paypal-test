class PayPalAuthentication < ActiveRecord::Base
  belongs_to :user

  # filter
  scope :for_user_id, ->(user_id) { where(user_id: user_id) }
end
