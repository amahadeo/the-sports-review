class ArticlePolicy < ApplicationPolicy
  def index?
    true
  end
  
  def feed_index?
    user.present?
  end
  
  def newest_index?
    true
  end
  
  def show?
    true
  end
  
  def create?
    user.present?
  end
  
  def update?
    user.present? && (record.user == user)
  end
  
  def destroy?
    update?
  end
end