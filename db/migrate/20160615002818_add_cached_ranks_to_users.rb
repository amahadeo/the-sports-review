class AddCachedRanksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :top_rank, :integer, :default => 0
    add_index :users, :top_rank
    add_column :users, :trend_rank, :integer, :default => 0
    add_index :users, :trend_rank
  end
end
