class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # list create update delete
end
