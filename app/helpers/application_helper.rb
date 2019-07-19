module ApplicationHelper
  def category_button(impact)
    if impact == 'low'
      'btn btn-category-iii'
    elsif impact == 'medium'
      'btn btn-category-ii'
    elsif impact == 'high'
      'btn btn-category-i'
    elsif impact == 'critical'
      'btn btn-category-i'
    end
  end

  def status_label(symbol)
    symbol.to_s.titleize
  end

  def status_btn(symbol)
    case symbol
    when :not_applicable then 'btn btn-info'
    when :failed then 'btn btn-danger'
    when :passed then 'btn btn-success'
    when :not_reviewed then 'btn btn-neutral'
    else
      'btn btn-neutral'
    end
  end

  def result_message(symbol)
    if symbol == :not_applicable
      'Justification'
    elsif symbol == :failed
      'One or more of the automated tests failed or was inconclusive for the control'
    elsif symbol == :passed
      'All Automated tests passed for the control'
    elsif symbol == :not_reviewed
      'Automated test skipped due to known accepted condition in the control'
    else
      'No test available for this control'
    end
  end

  def ary_to_s(val)
    return '' if val.nil? || val.empty?

    val.size == 1 ? val.first.to_s.delete('"') : val.to_s.delete('"')
  end

  def pass_pixels(findings)
    Rails.logger.debug "FINDINGS: #{findings}"
    if findings and findings[:passed] != 0
      (findings[:passed] / (findings[:failed] + findings[:passed] + findings[:profile_error] + findings[:not_reviewed]).to_f * 200.0).round
    else
      0
    end
  end

  def fail_pixels(findings)
    200 - pass_pixels(findings)
  end

  def compliance(findings)
    (findings[:passed] / (findings[:failed] + findings[:passed] + findings[:profile_error] + findings[:not_reviewed]).to_f * 100.0).round(2)
  end

  def icon(clss)
    if clss == Evaluation
      'ion-pie-graph'
    elsif clss == Profile
      'ion-ios-folder'
    elsif clss == User
      'ion-person-add'
    end
  end

  def destroy_user_session_path(user)
    case user.class
    when DbUser then destroy_db_user_session_path
    when LdapUser then destroy_ldap_user_session_path
    end
  end

  def flash_class(level)
    case level.to_sym
    when :notice then 'alert alert-info'
    when :success then 'alert alert-success'
    when :error then 'alert alert-error'
    when :alert then 'alert alert-error'
    end
  end
end
