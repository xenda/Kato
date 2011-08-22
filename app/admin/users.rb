ActiveAdmin.register User do

  index do
    column :id do |user|
      auto_link(user)
    end
    column :email
    column :name
    column :facebook_token
    column :facebook_uid
  end
  
end
