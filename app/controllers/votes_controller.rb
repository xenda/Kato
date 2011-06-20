class VotesController < InheritedResources::Base
  
  before_filter :authenticate_user!
	respond_to :xml, :json, :js
	
  def create
    @vote = Vote.new(params[:vote])
    @vote.user = current_user
    create!
  end
end
