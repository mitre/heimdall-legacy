class CopyImpacts < ActiveRecord::Migration[5.2]
  def up
    Control.all.each do |control|
      if control.impact_string == 'none'
        control.impact = 0.0
      elsif control.impact_string == 'low'
        control.impact = 0.3
      elsif control.impact_string == 'medium'
        control.impact = 0.5
      elsif control.impact_string == 'high'
        control.impact = 0.7
      elsif control.impact_string == 'critical'
        control.impact = 1.0
      end
      control.save
    end
  end

  def down
  end
end
