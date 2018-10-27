module CategoriesHelper
  def readable_name(name)
    ("<span class='name'>" + "#{name.split.map(&:capitalize).join(' ')}" + "</span>").html_safe
  end
end
