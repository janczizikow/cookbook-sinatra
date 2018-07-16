require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'

# set :bind, '0.0.0.0'

require_relative './recipe'
require_relative './cookbook'
require_relative './scraper'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__FILE__)
end

COOKBOOK = Cookbook.new(File.join(__dir__, 'recipes.csv'))
SCRAPER = Scraper.new

get '/' do
  @recipes = COOKBOOK.all
  erb :index
end

get '/new' do
  erb :new
end

# FIXME: this should be "delete"
post '/destroy/:index' do
  COOKBOOK.remove_recipe(params[:index].to_i)
  redirect '/'
end

post '/recipes' do
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

get '/search' do
  @query = params[:query]
  @recipes = SCRAPER.fetch_recipes(params[:query])
  erb :search
end

post '/add/:index' do
  new_recipe = Recipe.new(
    params[:name],
    params[:description],
    params[:prep_time],
    params[:diff],
    params[:is_done]
  )
  COOKBOOK.add_recipe(new_recipe)
  redirect '/'
end
