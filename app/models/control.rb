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
  field :descriptions, type: Array, default: []
  embeds_many :tags, cascade_callbacks: true
  field :sl_ref, type: String
  field :sl_line, type: Integer
  belongs_to :profile, inverse_of: :controls
  has_many :results
  validates_presence_of :control_id
  validate :code_is_valid

  def to_jbuilder
    Jbuilder.new do |json|
      json.extract! self, :title, :desc, :impact, :refs
      json.tags do
        tags.each do |tag|
          json.set!(tag.name, tag.value)
        end
      end
      json.extract! self, :code
      json.source_location do
        json.ref sl_ref
        json.line sl_line
      end
      json.id control_id
      if results.present?
        json.results(results.collect { |result| result.to_jbuilder.attributes! })
      end
    end
  end

  def as_json
    to_jbuilder.attributes!
  end

  def to_json
    to_jbuilder.target!
  end

  def is_editable?
    results.empty?
  end

  def refs_list=(arg)
    self.refs = arg.split(',').map(&:strip)
  end

  def refs_list
    refs.join(', ')
  end

  def start_time
    results.map(&:start_time).min
  end

  def run_time
    results.map(&:run_time).inject(0, :+).round(6)
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

  def parse_nist_tag(nist_tag)
    if (m_fields = nist_tag.match(/([A-Z]{2})\-(\d+)((\s*([a-z])|\.([a-z])){1}((\.|\s+)(\d+))?)?\s*(\(\d+\))?((\s*([a-z])|\.([a-z])|\s*\(([a-z])\)){1}((\.|\s+)(\d+))?)?/))
      # <MatchData "AC-15 a 3(2) b 2" 1:"AC" 2:"15" 3:" a 3" 4:" a" 5:"a" 6:nil 7:" 3" 8:" " 9:"3" 10:"(2)" 11:" b 2" 12:" b" 13:"b" 14:nil 15:nil 16:" 2" 17:" " 18:"2">
      value = "#{m_fields[1]}-#{m_fields[2]}"
      value += ".#{m_fields[5] || m_fields[6]}" if m_fields[4].present?
      value += ".#{m_fields[9]}" if m_fields[9].present?
      value += m_fields[10] if m_fields[10].present?
      value += ".#{m_fields[13] || m_fields[14] || m_fields[15]}" if m_fields[12].present?
      value += ".#{m_fields[18]}" if m_fields[18].present?
      value
    else
      nist_tag
    end
  end

  def nist_tags
    values = []
    if (nist_tags = tag('nist'))
      nist_tags.split(',').map(&:strip).each do |nist_tag|
        values << parse_nist_tag(nist_tag)
      end
    end
    values
  end

  def short_title
    title.nil? ? '' : "#{title[0..50]}..."
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
