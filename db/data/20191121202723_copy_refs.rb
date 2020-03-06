class CopyRefs < ActiveRecord::Migration[5.2]
  def up
    Control.where.not(refs_array: nil).each do |control|
      unless control.refs_array.empty?
        control.refs_array.each do |ref|
          if ref.key?('ref') and ref['ref'].is_a?(String)
            control.refs.create(ref: ref['ref'], url: ref['url'], uri: ref['uri'])
          end
        end
      end
    end
  end

  def down
    Ref.all.each do |ref|
      ref.destroy
    end
  end
end
