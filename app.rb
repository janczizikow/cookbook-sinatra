require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'

require_relative './recipe'
require_relative './cookbook'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__FILE__)
end

COOKBOOK = Cookbook.new(File.join(__dir__, 'recipes.csv'))

get '/' do
  @recipes = COOKBOOK.all
  erb :index
end

get '/new' do
  erb :new
end

get '/destroy/:index' do
  # params.to_s
  # puts params[:index]
  COOKBOOK.remove_recipe(params[:index].to_i)
  redirect '/'
end

post '/recipes' do
  # params.to_s
  new_recipe = Recipe.new(
    params[:name],
    params[:desc],
    params[:prep_time],
    params[:diff],
    params[:is_done]
  )
  COOKBOOK.add_recipe(new_recipe)
  redirect '/'
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end
