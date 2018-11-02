class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :current_order
  before_action :current_user


  def current_order
    if session[:order_id]
      @current_order = Order.find_by(id: session[:order_id].to_i)
    else
      @current_order = generate_cart
    end
  end

  def current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user = User.create(uid: 0, provider: "sovietski")
    end
  end

  private

    def generate_cart
      order = Order.new(status: "pending")
      order.user_id = current_user.id
      order.save

      return order
    end

end
