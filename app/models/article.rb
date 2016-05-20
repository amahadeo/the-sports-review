class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  validates :title, length: { minimum: 5 }, presence: true, uniqueness: true
  validates :body, length: {minimum: 20 }, presence: true
  validates :user, presence: true
  
  searchable do
    text :title, :boost => 3
    text :body
    text :comments do
      comments.map(&:body)
    end
    text :user_name
  end
  
  def user_name
    user.username
  end
end
