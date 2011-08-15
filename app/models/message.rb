class Message < ActiveRecord::Base

  # associations
  belongs_to :user
  belongs_to :category
  has_many :ingredients
  accepts_nested_attributes_for :ingredients

  validates_presence_of :title, :on => :create, :message => "debes agregar un nombre"

  has_attached_file :photo,
    :styles => {:thumb => "155x150#", :big => "570x300#"},
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => '/:attachment/:id/:filename'

  scope :published, where("published=true")

  scope :most_voted, published.limit(4).order("votes_count DESC")

  attr_accessor :dni

  def self.validate_user(dni)
    # return true if dni == "42911429"
    if Rails.env == "production"
      !Client.where(:document_number => dni).all.empty?
    else
      true
    end
    # false
  end

  def twitter_link
    link = "http://twitter.com/share?url="
    link << URI.escape("http://apps.facebook.com/masbuenoqueelpan/recetas/#{self.id}")
    link
  end

  def photo_url
    if photo_file_name
      photo.url(:big)
    else
      "http://alpha-kato.heroku.com/images/default.jpg"
    end
  end

  def user
    User.where(:facebook_token => self.token.to_s).first
  end

end
