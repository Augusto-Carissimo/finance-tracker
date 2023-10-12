class StocksController < ApplicationController
  def search
    if params[:stock].present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        update_search
      else
        flash[:alert] = "Please enter a valid symbol to search"
        redirect_to my_portfolio_path
      end
    else
      flash[:alert] = "Please enter a symbol to search"
      redirect_to my_portfolio_path
    end
  end

  private

  def update_search
    render turbo_stream:
    turbo_stream.replace('results_turbo_stream', partial: 'users/results')
  end
end
