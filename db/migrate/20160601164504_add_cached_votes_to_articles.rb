class AddCachedVotesToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :cached_votes_score, :integer, :default => 0
    add_index :articles, :cached_votes_score
  end
end
