module OrderItemsHelper
end






<div class="form-group">
  <%= f.label :image_http_address %>
  <%= f.text_field :img_file, placeholder: "GIF, JPG, or PNG file name" class: "form-control"  %>
</div>


use f.number_field for capacity

add placeholder img

(update params in controllers to accept new changes in the forms)

helper:
 - products helper

def find_image_for(product)
  if product.img_file.blank?
  image_tag("default.png")
  else
  image_tag(product.img_file)
  end
end
 - find_image(product)
 if product.image_file


   <div class="form-group">
     <%= f.label :image_http_address %>
     <%= f.text_field :img_file, class: "form-control"  %>
   </div>
