class GamesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter -> {@game = Game.includes(:users).find(params[:id])}, :only => [:show, :edit, :update, :join]

  def index
    @games = Game.all
    @open_games = Game.open
    @recent_games = Game.recent
    @active_games = Game.active
  end

  def show

  end

  def create
    game = Game.create(:grid => Array.new(3) { Array.new(3,-1) },
                :state => {:rows => Array.new(3, 0), :columns => Array.new(3, 0), :diags => Array.new(3, 0)},
                :status => Game::TYPES[:open],
                :user_ids => [current_user.id]
    )
    redirect_to edit_game_path(game)
  end

  def edit

  end

  def update
    @game.move(current_user, params[:move])

    respond_to do |format|
      format.html { redirect_to edit_game_path(@game)}
      format.json { render json: @game }
    end
  end

  def join
    if @game.status == Game::TYPES[:open]
      @game.join(current_user)
      redirect_to edit_game_path, :notice => 'Joined game successfully'
    else
      redirect_to games_path, :warning => 'This game is longer open. Please try another'
    end
  end

  def move

  end

end
