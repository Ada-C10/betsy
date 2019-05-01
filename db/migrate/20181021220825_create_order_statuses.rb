class CreateOrderStatuses < ActiveRecord::Migration[5.2]
  def change
    # drop_table :order_statuses, force: :cascade
    create_table :order_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
