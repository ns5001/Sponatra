class AddColumnToTable < ActiveRecord::Migration
  def change
    add_column :songs, :spotify, :string
  end
end
