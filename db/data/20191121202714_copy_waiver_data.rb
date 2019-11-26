class CopyWaiverData < ActiveRecord::Migration[5.2]
  def up
    Control.where.not(waiver_data_hash: nil).each do |control|
      wd = WaiverData.create(justification: control.waiver_data_hash['justification'],
                                 run: control.waiver_data_hash['run'],
                                 skipped_due_to_waiver: control.waiver_data_hash['skipped_due_to_waiver'],
                                 message: control.waiver_data_hash['message'])
      control.waiver_data = wd
    end
  end

  def down
    WaiverData.each do |waiver_data|
      waiver_data.destroy
    end
  end
end
