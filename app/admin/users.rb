ActiveAdmin.register User do

  index do
    column :id
    column :email do |user|
      auto_link(user)
    end
    column :name
    column :facebook_token
    column :facebook_uid
  end
  
end
