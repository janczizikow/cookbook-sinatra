require 'open-uri'
require 'nokogiri'
require_relative 'recipe'

class Scraper
  BASE_URL = 'http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt='

  def fetch_recipes(ingredient)
    url = URI.parse(BASE_URL + ingredient).open
    html_content = Nokogiri::HTML(url)
    recipies = []

    html_content.search('.m_contenu_resultat').each do |node|
      title = node.children.children[1].text
      description = node.children.children[19].text.strip
      prep_time = node.children.children[4].children.text.strip
      diff = node.children[7].children.text.strip.scan(/[^-\s+]\w+/)[2]
      recipies << Recipe.new(title, description, prep_time, diff)
    end

    recipies.take(10)
  end
end
