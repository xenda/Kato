class Message < ActiveRecord::Base

  # associations
  belongs_to :user
  belongs_to :category
  has_many :ingredients
  accepts_nested_attributes_for :ingredients

  validates_presence_of :title, :on => :create, :message => "no puede estar vac&iacute;o"

  has_attached_file :photo,
    :styles => {:thumb => "180x150#", :big => "570x300#"},
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => '/:attachment/:id/:filename'



  scope :most_voted, limit(4).order("votes_count DESC")

  attr_accessor :dni

  def self.validate_user(dni)
    # return true if dni == "42911429"
    not Client.where(:document_number => dni).all.empty?
    # false
  end

  def photo_url
    if photo_file_name
      photo.url(:big)
    else
      "http://alpha-kato.heroku.com/images/default.jpg"
    end
  end

end
