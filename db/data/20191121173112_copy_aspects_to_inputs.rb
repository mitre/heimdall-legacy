class CopyAspectsToInputs < ActiveRecord::Migration[5.2]
  def up
    Aspect.all.each do |aspect|
      Input.create(name: aspect.name, options: aspect.options, profile_id: aspect.profile_id)
    end
  end

  def down
    Input.all.each do |input|
      input.destroy
    end
  end
end
