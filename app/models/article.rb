require 'elasticsearch/model'

class Article < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  validates :title, length: { minimum: 5 }, presence: true, uniqueness: true
  validates :body, length: {minimum: 20 }, presence: true
  validates :user, presence: true
end

Article.import force: true
