class FriendshipsController < ApplicationController
  def index
    @friendships = current_user.friends
  end

  def create
    friendship = current_user.friendships.build(friend_id: params[:friend])
    if friendship.save
      flash[:notice] = 'Friend was added'
      redirect_to friendships_path
    else
      flash[:alert] = 'Has been an error'
      redirect_to friendships_path
    end
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = 'Friend was remove'
    redirect_to friendships_path
  end

  def search
    if params[:user].present?
      @friends = User.search(params[:user])
      @friends = current_user.except_current_user(@friends)
      if @friends
        update_friends
      else
        flash[:alert] = "Friend not found"
        redirect_to friendships_path
      end
    else
      flash[:alert] = "Please enter a symbol to search"
      redirect_to friendships_path
    end
  end

  private

  def update_friends
    render turbo_stream:
    turbo_stream.replace('results_turbo_stream', partial: 'friendships/results')
  end

  def update_list
    render turbo_stream:
    turbo_stream.replace('list_turbo_stream', partial: 'users/list')
  end
end
