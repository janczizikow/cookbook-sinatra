require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @csv = csv_file_path
    @recipes = []
    load_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    # add the new recipe to the array
    @recipes << recipe
    # save csv
    save_csv!
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    # save csv
    save_csv!
  end

  def mark_as_done(recipe_index)
    @recipes[recipe_index].mark_as_done!
    # save csv
    save_csv!
  end

  private

  def load_csv
    CSV.foreach(@csv, headers: :first_row) do |row|
      @recipes << Recipe.new(
        row['name'],
        row['description'],
        row['preparation time'],
        row['difficulty'],
        row['is done?'] == 'true'
      )
    end
  end

  def save_csv!
    CSV.open(@csv, 'wb') do |csv|
      csv << ['name', 'description', 'preparation time', 'difficulty', 'is done?']
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.diff, recipe.is_done]
      end
    end
  end
end
