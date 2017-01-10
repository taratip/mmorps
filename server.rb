require "sinatra"
require "pry"
require_relative "models/game"

set :bind, '0.0.0.0'  # bind to all interfaces

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

@human_score = 0
@computer_score = 0

rps_list = ["Rock", "Paper", "Scissors"]

get '/index' do
  if session[:game].nil?
    session[:game] = 1
  else
    session[:game] += 1

    if session[:show_message] == 'true'
      @message = session[:message]
      session[:show_message] = 'false'
    end

    @human_score = session[:human_score]
    @computer_score = session[:computer_score]
  end

  erb :index
end

post '/playgame' do
  player = params[:selection]
  computer = rps_list.sample

  if session[:human_score].nil? && session[:computer_score].nil? && session[:total_game].nil?
    human_score = 0
    computer_score = 0
    total_game = 0
  end

  human_score = session[:human_score].to_i
  computer_score = session[:computer_score].to_i
  total_game = session[:total_game].to_i

  #play one game
  player_win = Game.win?(player, computer)
  total_game += 1
  who_score = ""
  if player_win == "win"
    who_score = "Human scores."
    human_score += 1
  elsif player_win == "lose"
    who_score = "Computer scores."
    computer_score += 1
  else
    who_score = "Tie, no winner."
  end

  if total_game == 3
    if human_score > computer_score
      winner_message = "Human wins!"
    else
      winner_message = "Computer wins!"
    end
  end

  message = "You chose #{player}, computer chose #{computer}. #{who_score}"
  session[:show_message] = 'true'
  session[:message] = message
  session[:human_score] = human_score
  session[:computer_score] = computer_score
  session[:total_game] = total_game

  if total_game == 3
    session[:winner_message] = winner_message

    redirect '/win'
  else
    redirect '/index'
  end
end

get '/win' do
  if session[:show_message] == 'true'
    @message = session[:message]
    session[:show_message] = 'false'
  end

  @human_score = session[:human_score]
  @computer_score = session[:computer_score]
  @winner_message = session[:winner_message]

  erb :win
end

get '/reset' do
  session.clear
  redirect '/index'
end
