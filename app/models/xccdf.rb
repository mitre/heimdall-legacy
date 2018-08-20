class Xccdf
  include Mongoid::Document
  include Mongoid::Timestamps
  field :benchmark_title, type: String
  field :benchmark_id, type: String
  field :benchmark_description, type: String
  field :benchmark_version, type: String
  field :benchmark_status, type: String
  field :benchmark_status_date, type: Date
  field :benchmark_notice, type: String
  field :benchmark_notice_id, type: String
  field :benchmark_plaintext, type: String
  field :benchmark_plaintext_id, type: String
  field :reference_href, type: String
  field :reference_dc_source, type: String
  field :reference_dc_publisher, type: String
  field :reference_dc_title, type: String
  field :reference_dc_subject, type: String
  field :reference_dc_type, type: String
  field :reference_dc_identifier, type: String
  field :content_ref_href, type: String
  field :content_ref_name, type: String
  validates_presence_of :benchmark_title
end
