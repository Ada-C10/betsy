crumb :root do
  link "Home", root_path
end

crumb :products do
  link "Products", products_path
  parent :root
end

crumb :product do |product|
  link product.name, product_path(project.id)
  parent :products
end

crumb :categories do
  link "Categories", categories_path
  parent :root
end

crumb :category do |category|
  link "category", category_path(category.id)

end

crumb :merchants do
  link "Merchants", merchants_path
  parent :root
end
crumb :merchants do |merchant|
  link "Merchant", merchant_path(merchant.id)
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
