module MessagesHelper

  def recipe_color(recipe)
    # color_id = recipe.id % 10
    "color_5"
  end

  def truncating_text_class(message)
     "longer" if message.size > 15
  end

end
