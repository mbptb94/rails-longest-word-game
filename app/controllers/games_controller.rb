require "uri"
require "net/http"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:userChoice]
    @letters = params[:computerChoice].split(' ')
    @choice = params[:userChoice].split('')
    @valideWord = ifvalide(@word)

    # tant que la première lettre du mot est dans la liste de lettres
    while @letters.include?(@choice[0])
      # enlève la premiere lettre du mot de la liste de l'ordi
      @letters.delete(@choice[0])
      # supprime la lettre
      @choice.delete_at(0)
    end
    # gagné s'il n'y a plus de lettres
    @has_won = @choice.empty?

    # redonner les valeurs d'origine pour ne pas afficher sous forme de tableau
    @letters = params[:computerChoice]
    @choice = params[:userChoice]

    # conditions pour savoir si l'user a gagne
    if !@has_won
      @result = "Sorry but '#{@word}' can't be built out of #{@letters}"
    elsif !@valideWord
      @result = "Sorry but '#{@word}' does not seem to be a valid English word..."
    else
      @result = "Congratulations! '#{@word}' is a valid English word!"
    end
  end

  private

  # methode pour recupérer l'APi et vérifier
  def ifvalide(word)
  url = URI("https://dictionary.lewagon.com/#{word}")
  response = URI.open(url).read

  json = JSON.parse(response)
  json['found']
  end
end
