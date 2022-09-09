class Post < ApplicationRecord
  has_one :rating, dependent: :destroy
end
