module ApplicationHelper
  def category_button(impact)
    if impact <= 0.3
      'btn btn-category-iii'
    elsif impact <= 0.6
      'btn btn-category-ii'
    elsif impact <= 0.9
      'btn btn-category-i'
    end
  end

  def status_label(symbol)
    symbol.to_s.titleize
  end

  def status_btn(symbol)
    case symbol
    when :not_applicable then 'btn btn-info'
    when :open then 'btn btn-danger'
    when :not_a_finding then 'btn btn-success'
    when :not_reviewed then 'btn btn-neutral'
    else
      'btn btn-neutral'
    end
  end

  def result_message(symbol)
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
