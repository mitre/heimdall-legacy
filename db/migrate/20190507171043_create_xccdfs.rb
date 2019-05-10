class CreateXccdfs < ActiveRecord::Migration[5.2]
  def change
    create_table :xccdfs do |t|
      t.string :benchmark_title
      t.string :benchmark_id
      t.string :benchmark_description
      t.string :benchmark_version
      t.string :benchmark_status
      t.datetime :benchmark_status_date
      t.string :benchmark_notice
      t.string :benchmark_notice_id
      t.string :benchmark_plaintext
      t.string :benchmark_plaintext_id
      t.string :reference_href
      t.string :reference_dc_source
      t.string :reference_dc_publisher
      t.string :reference_dc_title
      t.string :reference_dc_subject
      t.string :reference_dc_type
      t.string :reference_dc_identifier
      t.string :content_ref_href
      t.string :content_ref_name

      t.timestamps
    end
  end
end
