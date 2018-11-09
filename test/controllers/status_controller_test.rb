require "test_helper"

describe StatusController do
  before do
    @item = items(:shoes)
    @order = orders(:one)
    @new_order_item = OrderItem.create(order_id: @order.id, item_id: @item.id)
  end

  it 'will load a form to find an order' do
    get status_findform_path

    must_respond_with :success
  end

  it 'responds with success if the order exists' do
    post detail_path

    must_respond_with :success
  end

  it 'responds with success if the order exists' do
    get status_path(@order.id)

    must_respond_with :success
  end
end
