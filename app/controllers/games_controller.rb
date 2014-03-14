class GamesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter -> {@game = Game.includes(:users).find(params[:id])}, :only => [:show, :edit]

  def index
    @games = Game.all
    @current_user = current_user
  end

  def create
    inits = Array.new(3, 0)
    Game.create(:grid => Array.new(3, inits),
                :state => {:rows => inits, :columns => inits, :diags => inits},
                :status => Game::TYPES[:open],
                :user_ids => [current_user.id]
    )
  end

  def show

  end

  def edit
    @game = Game.find(params[:id])
  end

end
