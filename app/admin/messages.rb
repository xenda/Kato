ActiveAdmin.register Message do

  index do
    column :title do |message|
      auto_link(message)
    end
    column :content do |message|
      simple_format truncate(message.content, :length => 40)
    end
    column :user do |message|
      message.try(:user).try(:email)
    end
    column :created_at
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
      f.input :token
    end
    f.buttons
  end
  
end
