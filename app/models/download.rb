require 'render_anywhere'

class Download
  include RenderAnywhere

  def initialize(evaluation)
    @evaluation = evaluation
    file = File.read("#{Rails.root}/data/nist_800_53.json")
    @nist_800_53_json = JSON.parse(file)
    @nist_hash = @nist_800_53_json.deep_dup
    @profiles = @evaluation.profiles
    @counts, @controls = @evaluation.status_counts
    @symbols = {}
    @controls.each do |_, hsh|
      control = hsh[:control]
      @symbols[control.control_id] = hsh[:status_symbol]
    end
    @profiles.each do |profile|
      families, nist = profile.control_families
      next if families.empty?
      @nist_hash['children'].each do |cf|
        family_value = 0
        cf['children'].each do |control|
          if families.include?(control['name'])
            control['controls'] = nist[control['name']]
            control['value'] = control['controls'].size
            family_value += control['controls'].size
          else
            control['value'] = 0
          end
        end
        cf['value'] = family_value
      end
    end
  end

  def to_pdf
    options = {
      'margin-top': '0.10in',
      'margin-right': '0.10in',
      'margin-bottom': '0.10in',
      'margin-left': '0.10in'
    }
    kit = PDFKit.new(as_html, options=options)
    kit.to_file('tmp/ssp.pdf')
  end

  def filename
    'SSP.pdf'
  end

  private

  attr_reader :invoice

  def as_html
    render template: 'evaluations/ssp_pdf',
      layout: 'ssp_pdf',
      locals: { evaluation: @evaluation, nist_hash: @nist_hash, symbols: @symbols }
  end
end
