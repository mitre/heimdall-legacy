module ApplicationHelper

  def category_button impact
    if impact <= 0.3
      return "btn btn-category-iii"
    end
    if impact <= 0.6
      return "btn btn-category-ii"
    end
    if impact <= 0.9
      return "btn btn-category-i"
    end
  end

end
