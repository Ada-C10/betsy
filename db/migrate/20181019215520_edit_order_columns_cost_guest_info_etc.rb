class EditOrderColumnsCostGuestInfoEtc < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :guest_email, :string
    add_column :orders, :guest_mailing, :string
    add_column :orders, :guest_cc_name, :string
    add_column :orders, :guest_cc_num, :string
    add_column :orders, :guest_cc_exp_date, :string
    add_column :orders, :guest_cc_cvv_code, :string
    add_column :orders, :guest_cc_zip, :string

    remove_column :orders, :guest_user_info, :string
    remove_column :orders, :date_time_placed, :datetime
    remove_column :orders, :total_price, :integer

    remove_reference(:orders, :order_item, index: true, foreign_key: true)
  end
end
