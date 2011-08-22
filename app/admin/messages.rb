ActiveAdmin.register Message do

  index do
    column :title do |post|
      auto_link(post)
    end
    column :user do |post|
      post.try(:user).try(:email)
    end
    column :photo do |post|
      image_tag post.photo.url(:default)
    end
    column :published
  end

  show do
    div do
      message.try(:user).try(:email)
    end
    div do
      simple_format message.content
    end
    div do
      image_tag message.photo.url(:big)
    end
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :title
      f.input :content
      f.input :photo
      f.input :published
    end
    f.buttons
  end
  
end
