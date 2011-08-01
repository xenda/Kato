class VotesController < InheritedResources::Base

  #before_filter :authenticate_user!
	respond_to :xml, :json, :js
  #after_filter :send_to_pusher

  def create
    @vote = Vote.new(params[:vote])
    @vote.user = current_user
    @vote.user ||= User.first
    @message = @vote.message
    create!
  end

  private

  def send_to_pusher
    if @vote.errors.empty?
      @message.reload
      Pusher['alpha-skunk'].trigger!('vote:create', {:message_id => @vote.message_id, :votes_count => @message.votes_count})
    end
  end

end
