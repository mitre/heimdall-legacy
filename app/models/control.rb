require 'ripper'

class Control
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  field :title, type: String
  field :desc, type: String
  field :impact, type: Float
  field :refs, type: Array, default: []
  field :code, type: String
  field :control_id, type: String
  embeds_many :tags, cascade_callbacks: true
  field :sl_ref, type: String
  field :sl_line, type: Integer
  belongs_to :profile, inverse_of: :controls
  has_many :results
  validates_presence_of :control_id
  validate :code_is_valid

  def is_editable?
    results.empty?
  end

  def refs_list=(arg)
    self.refs = arg.split(',').map(&:strip)
  end

  def refs_list
    refs.join(', ')
  end

  def tag name
    val = tags.where(name: name).first.try(:value)
    val.is_a?(Array) ? val.join(", ") : val
  end

  def eval_results evaluation_id
    results.where(evaluation_id: evaluation_id)
  end

  def severity
    if impact <= 0.3
      "low"
    elsif impact <= 0.6
      "medium"
    elsif impact <= 0.9
      "high"
    end
  end

  def self.parse code
    return nil if code.nil?
    control = nil
    tokens = Ripper.sexp(code)
    return nil unless tokens
    begin
      contrl_cmd = tokens[1][0][1]
      return nil unless contrl_cmd[1][1] == "control"
      control_id = contrl_cmd[2][1][0][1][1][1]
      control = Control.new(control_id: control_id)
      do_block = tokens[1][0][2]
      cmds = do_block[2].select{|block| block[0] == :command}
      cmds.each do |cmd|
        field = cmd[1][1]
        if field == "title"
          control.title = cmd[2][1][0][1][1][1]
        elsif field == "desc"
          control.desc = cmd[2][1][0][1][1][1]
        elsif field == "impact"
          control.impact = Float(cmd[2][1][0][1])
        elsif field == "tag"
          tag_name = cmd[2][1][0][1][0][1][1][1][1]
          tag_value = nil
          tag_content = cmd[2][1][0][1][0][2]
          if tag_content[0] == :string_literal
            tag_value = tag_content[1][1][1]
          elsif tag_content[0] == :array
            tag_value = []
            tag_content[1].each do |string_content|
              tag_value << string_content[1][1][1]
            end
          end
          control.tags << Tag.new(name: tag_name, value: tag_value)
        end
      end
    rescue
      logger.debug "Couldn't parse control code #{code}"
      control = nil
    end
    control
  end

  private

  def code_is_valid
    if code && Ripper.sexp(code).nil?
      errors.add(:code, 'is not valid ruby')
    end
  end
end
