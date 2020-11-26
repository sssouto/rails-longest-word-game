class GamesController < ApplicationController
  require 'open-uri'
  require 'json'

  def new
    source = ('A'..'Z').to_a
    set_of_letters = []
    10.times { set_of_letters << source.sample }
    @letters = set_of_letters
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    api_result = JSON.parse(open(url).read)
    letters_array = params[:letters].scan(/\w/)
    word_array = params[:word].scan(/\w/).map(&:upcase)
    @message = if api_result['found'] == false
                 "Sorry but #{params[:word].upcase} does not seem to be a valid English word..."
               elsif word_array.all? do |letter|
                       (letters_array.include? letter) && (word_array.count(letter) <= letters_array.count(letter))
                     end
                 "Congratulations! #{params[:word].upcase} is a valid English word!"
               else
                 "Sorry but #{params[:word].upcase} can't be built out of #{params[:letters]}"
               end
  end
end
