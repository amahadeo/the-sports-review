class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  
  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true
  validates :article, presence: true
end
