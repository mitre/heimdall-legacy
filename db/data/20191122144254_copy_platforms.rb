class CopyPlatforms < ActiveRecord::Migration[5.2]
  def up
    Evaluation.where.not(platform_hash: nil).each do |eval|
      pf = Platform.create(name: eval.platform_hash['name'], release: eval.platform_hash['release'])
      eval.platform = pf
    end
  end

  def down
    Platform.all.each do |platform|
      platform.destroy
    end
  end
end
