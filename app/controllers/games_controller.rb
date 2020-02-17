require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('a'..'z').to_a
    @letters = []
    10.times { @letters << alphabet.sample }
  end

  def score
    @word = params[:answer].upcase.split('')
    @grid = params[:grid].upcase.split('')
    @letters = @grid.join(', ')
    @score = session[:score]

    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)

    unless @word.all? { |letter| @word.count(letter) <= @grid.count(letter) }
      @score = "Sorry but #{params[:answer].upcase} can't be built out of #{@letters}"
    end

    session[:score] += params[:answer].length

    if word['found']
      @score = "Congratulations! #{params[:answer].upcase} is a valid English word!"
    else
      @score = "Sorry but #{params[:answer].upcase} does not seem to be a valid English word..."
    end
  end
end
