class AddCachedRanksToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :top_rank, :float
    add_column :articles, :trend_rank, :float
    add_index :articles, :top_rank
    add_index :articles, :trend_rank
  end
end
