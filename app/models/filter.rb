class Filter
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Userstamps::Model
  field :family, type: Array, default: []
  field :number, type: Array, default: []
  field :sub_fam, type: Array, default: []
  field :sub_num, type: Array, default: []
  field :enhancement, type: Array, default: []
  field :enh_sub_fam, type: Array, default: []
  field :enh_sub_num, type: Array, default: []
  has_and_belongs_to_many :filter_groups

  def self.valid_filter(params)
    %w{family number sub_fam sub_num enhancement enh_sub_fam enh_sub_num}.each do |field|
      if params.key?(field)
        params[field] = params[field].split(',') if params[field].is_a?(String)
      else
        params[field] = []
      end
    end
    if params['enhancement'].size != 1 || params['enhancement'].first == 'none'
      params['enh_sub_fam'] = []
      params['enh_sub_num'] = []
    end
    Filter.new(
      family: params['family'],
      number: params['number'],
      sub_fam: params['sub_fam'],
      sub_num: params['sub_num'],
      enhancement: params['enhancement'],
      enh_sub_fam: params['enh_sub_fam'],
      enh_sub_num: params['enh_sub_num'],
    )
  end

  def reg_sub_num
    if sub_num.nil? || sub_num.empty?
      '(\.\d+)?'
    elsif sub_num.size == 1
      '\.' + sub_num.first
    else
      '\.(' + sub_num.join('|') + ')'
    end
  end

  def reg_sub_fam
    if sub_fam.nil? || sub_fam.empty?
      '(\.[a-z]{1})?(\.\d+)?'
    elsif sub_fam.size == 1
      '\.' + sub_fam.first + reg_sub_num
    else
      '\.(' + sub_fam.join('|') + ')(\.\d+)?'
    end
  end

  def reg_number
    if number.nil? || number.empty?
      '\d+' + reg_sub_fam
    elsif number.size == 1
      number.first + reg_sub_fam
    else
      '(' + number.join('|') + ')(\.[a-z]{1})?(\.\d+)?'
    end
  end

  def reg_enh_sub_num
    if enh_sub_num.nil? || enh_sub_num.empty?
      '(\.\d+)?\Z'
    elsif enh_sub_num.size == 1
      '\.' + enh_sub_num.first + '\Z'
    else
      '\.(' + enh_sub_num.join('|') + ')\Z'
    end
  end

  def reg_enh_sub_fam
    if enh_sub_fam.nil? || enh_sub_fam.empty?
      '(\.[a-z]{1}(\.\d+)?)?\Z'
    elsif enh_sub_fam.size == 1
      '\.' + enh_sub_fam.first + reg_enh_sub_num
    else
      '\.(' + enh_sub_fam.join('|') + ')(\.\d+)?\Z'
    end
  end

  def reg_enhancement
    if enhancement.nil? || enhancement.empty?
      ''
    elsif enhancement.size == 1
      if enhancement.first == 'none'
        '\Z'
      else
        '\(' + enhancement.first + '\)' + reg_enh_sub_fam
      end
    else
      '\((' + enhancement.join('|') + ')\)' + + reg_enh_sub_fam
    end
  end

  # AC-15.a.3(2).b.2
  def reg_family
    if family.nil? || family.empty?
      '\b[A-Z]{2}.*'
    elsif family.size == 1
      '\b' + family.first + '\-' + reg_number + reg_enhancement
    else
      '\b(' + family.join('|') + ').*'
    end
  end

  def regex
    reg_str = reg_family
    Object::Regexp.new reg_str
  end

  def ary_to_s(val)
    val.size == 1 ? val.first.to_s : val.to_s
  end

  def family_s
    val = "#{ary_to_s(family)}-"
    if number.nil? || number.empty?
      val += '*'
    else
      val += ary_to_s(number)
      if sub_fam&.present?
        val += ".#{ary_to_s(sub_fam)}"
        if sub_num&.present?
          val += ".#{ary_to_s(sub_num)}"
        end
      end
    end
    val
  end

  def to_s
    if family&.present?
      val = family_s
    else
      val = '*'
    end
    if enhancement&.present?
      if enhancement.first == 'none'
        val += "\Z"
      else
        val += "(#{enhancement})"
      end
      if enh_sub_fam&.present?
        val += ".#{ary_to_s(enh_sub_fam)}"
        if enh_sub_num&.present?
          val += ".#{ary_to_s(enh_sub_num)}"
        end
      end
    end
    val.delete '"'
  end
end
