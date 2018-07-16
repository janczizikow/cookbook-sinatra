class Recipe
  attr_reader :name, :description, :prep_time, :diff, :is_done
  def initialize(name, description, prep_time, diff = 'n/a', is_done = false)
    @name = name
    @description = description
    @prep_time = prep_time
    @diff = diff
    @is_done = is_done
  end

  def mark_as_done!
    @is_done = true
  end
end
