class DecksController < ApplicationController
  
  # GET /decks
  # GET /decks.xml
  def index
    @decks = Deck.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @decks }
    end
  end

  # GET /decks/1/edit
  def edit
    @deck = Deck.find(params[:id])
  end

  # PUT /decks/1
  # PUT /decks/1.xml
  def update
    @deck = Deck.find(params[:id])
    @game = Game.find(params[:game_id])
    @deck.shuffle
    redirect_to game_url(@game)
  end

  def draw
    @deck = Deck.find(params[:id])
    @game = Game.find(params[:game_id])
    drawn_card = @deck.first_card
    @act = Act.new(:card_state => drawn_card, :game => @game, :user => @user, :act_type => params[:act], :position => @game.next_act_position)
    @act.save
    if params[:act] == 'draw_to_hand'
      drawn_card.move_to_hand(@user)
    elsif params[:act] == 'play_from_deck'
      drawn_card.move_to_discard()
    end
    if @deck.empty_draw?
      @deck.shuffle
    else
      @deck.save
      @deck.get_draw.each do |c|
        c.update_attribute(:position, c.position-1)
      end
    end
    redirect_to game_act_url(@game, @act)
  end
  
  def play
    @deck = Deck.find(params[:id])
    @game = Game.find(params[:game_id])
    card = CardState.find(params[:card_id])
    @act = Act.new(:card_state => card, :game => @game, :user => @user, :act_type => 'play_from_hand', :position => @game.next_act_position)
    @act.save
    card.move_to_discard()
    redirect_to game_act_url(@game, @act)
  end
  
  #GET
  def give
    @deck = Deck.find(params[:id])
    @game = Game.find(params[:game_id])
    @card = CardState.find(params[:card_id])
    @players = @game.all_players
  end
  
  #POST
  def give_card
    @deck = Deck.find(params[:id])
    @game = Game.find(params[:game_id])
    card = CardState.find(params[:card_id])
    recipient = User.find(params[:recipient_id])
    @act = Act.new(:card_state => card, :game => @game, :user => @user, :act_type => 'give_to_player', :position => @game.next_act_position)
    @act.save()
    card.move_to_hand(recipient)
    redirect_to game_act_url(@game, @act)
  end

end
