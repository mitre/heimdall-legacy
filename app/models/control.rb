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

  def tag(name)
    val = tags.where(name: name).first.try(:value)
    val.is_a?(Array) ? val.join(', ') : val
  end

  def severity
    if impact <= 0.3 then 'low'
    elsif impact <= 0.6 then 'medium'
    elsif impact <= 0.9 then 'high'
    end
  end

  def parse_update(params)
    assign_attributes(params)
    if (new_control = Control.parse(params[:code]))
      self.title = new_control.title
      self.desc = new_control.desc
      self.impact = new_control.impact
      self.tags = new_control.tags
    end
  end

  def self.transform(controls)
    controls.try(:each) do |control|
      tags = control.delete('tags')
      control.delete('results')
      new_tags = []
      tags.each do |key, value|
        new_tags << { "name": key.to_s, "value": value }
      end
      control['tags'] = new_tags
      source_location = control.delete('source_location')
      source_location.try(:each) do |key, value|
        control["sl_#{key}"] = value
      end
    end
    controls
  end

  def self.parse(code)
    return nil if code.nil?
    control = nil
    tokens = Ripper.sexp(code)
    return nil unless tokens
    begin
      contrl_cmd = tokens[1][0][1]
      return nil unless contrl_cmd[1][1] == 'control'
      control = Control.new(control_id: contrl_cmd[2][1][0][1][1][1])
      do_block = tokens[1][0][2]
      cmds = do_block[2].select { |block| block[0] == :command }
      cmds.each do |cmd|
        control.parse_field cmd
      end
    rescue TypeError
      logger.debug "Couldn't parse control code #{code}"
      control = nil
    end
    control
  end

  def parse_tag(cmd)
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
    tags << Tag.new(name: tag_name, value: tag_value)
  end

  def parse_field(cmd)
    case cmd[1][1]
    when 'title'
      self.title = cmd[2][1][0][1][1][1]
    when 'desc'
      self.desc = cmd[2][1][0][1][1][1]
    when 'impact'
      self.impact = Float(cmd[2][1][0][1])
    when 'tag'
      parse_tag cmd
    end
  end

  private

  def code_is_valid
    if code && Ripper.sexp(code).nil?
      errors.add(:code, 'is not valid ruby')
    end
  end
end
