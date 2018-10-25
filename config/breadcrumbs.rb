crumb :root do
  link "Home", root_path
end

crumb :products do
  link "Products", products_path
  parent :root
end

crumb :product do |product|
  link "#{product.name}", product_path(product.id)
  parent :products
end

crumb :categories do
  link "Categories", categories_path
  parent :root
end

crumb :categories do |category|
  link "#{category.name}", category_path(category.id)
  parent :categories

end

crumb :merchants do
  link "Merchants", merchants_path
  parent :root
end
crumb :merchants do |merchant|
  link "#{merchant.name}", merchant_path(merchant.id)
  parent :merchants
end

crumb :orders do
  link "Orders", orders_path
  parent :root
end
crumb :orders do |order|
  link "#{order.id}", order_path(order.id)
  parent :orders
end

crumb :orderitems do
  link "Orderitems", orderitems_path
  parent :root
end
crumb :orderitems do |orderitem|
  link "#{orderitem.id}", orderitem_path(order.id)
  parent :orders
end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
