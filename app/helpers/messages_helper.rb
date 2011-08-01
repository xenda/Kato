module MessagesHelper

  def recipe_color(recipe)
    color_id = recipe.id % 10
    "color_#{color_id}"
  end

end
