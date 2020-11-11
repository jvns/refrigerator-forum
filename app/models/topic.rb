class Topic < ApplicationRecord
  has_many :posts
  def to_param
    "#{id}-#{title.parameterize}"
  end
end
