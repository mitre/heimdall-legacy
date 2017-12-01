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

  def status_label symbol
    symbol.to_s.titleize
  end

  def status_btn symbol
    if symbol == :not_applicable
      'btn btn-info'
    elsif symbol == :open
      'btn btn-danger'
    elsif symbol == :not_a_finding
      'btn btn-success'
    elsif symbol == :not_reviewed
      'btn btn-warning'
    else
      'btn btn-warning'
    end
  end

  def result_message symbol
    if symbol == :not_applicable
      'Justification'
    elsif symbol == :open
      'One or more of the automated tests failed or was inconclusive for the control'
    elsif symbol == :not_a_finding
      'All Automated tests passed for the control'
    elsif symbol == :not_reviewed
      'Automated test skipped due to known accepted condition in the control'
    else
      'No test available for this control'
    end
  end

end
