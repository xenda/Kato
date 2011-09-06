ActiveAdmin.register Message do

  index do
    column 'Titulo', :title do |message|
      auto_link(message)
    end
    column 'Contenido', :content do |message|
      simple_format truncate(message.content, :length => 40)
    end
    column 'Usuario', :user do |message|
      message.try(:user).try(:email)
    end
    column 'Fecha de creacion', :created_at
    column 'Votos Finales', :final_count
    column 'Publicado', :published
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

  csv do
    column('Votos') { |message| message.final_count.to_s }
    column('Titulo') { |message| message.title }
    column('E-Mail') { |message| message.try(:user).try(:email) }
    column('Usuario') { |message| message.try(:user).try(:name) }
    column('Contenido') { |message| message.content }
  end
  
end
