class RemoverequirementforUsercolumns < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :uid, :integer, optional: true
    change_column :users, :provider, :string, optional: true
  end
end
