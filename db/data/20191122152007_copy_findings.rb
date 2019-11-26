class CopyFindings < ActiveRecord::Migration[5.2]
  def up
    Evaluation.where.not(findings_hash: nil).each do |eval|
      finds = Finding.create(failed: eval.findings_hash['failed'],
                          passed: eval.findings_hash['passed'],
                          not_reviewed: eval.findings_hash['not_reviewed'],
                          profile_error: eval.findings_hash['profile_error'],
                          not_applicable: eval.findings_hash['not_applicable'])
      eval.finding = finds
    end
  end

  def down
    Finding.all.each do |finding|
      finding.destroy
    end
  end
end
