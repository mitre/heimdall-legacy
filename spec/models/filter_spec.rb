require 'rails_helper'

RSpec.describe Filter, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_and_belong_to_many(:filter_groups).of_type(FilterGroup) }

  it 'creates a regex' do
    filter = Filter.new
    expect(filter.to_s).to eq '*'
    expect(filter.regex).to eq(/\b[A-Z]{2}.*/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'])
    expect(filter.to_s).to eq 'AC-*'
    expect(filter.regex).to eq(/\bAC\-\d+(\.[a-z]{1})?(\.\d+)?/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: %w{AC IA SC})
    expect(filter.to_s).to eq '[AC, IA, SC]-*'
    expect(filter.regex).to eq(/\b(AC|IA|SC).*/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], number: ['7'])
    expect(filter.to_s).to eq 'AC-7'
    expect(filter.regex).to eq(/\bAC\-7(\.[a-z]{1})?(\.\d+)?/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], number: %w{1 2 3 7})
    expect(filter.to_s).to eq 'AC-[1, 2, 3, 7]'
    expect(filter.regex).to eq(/\bAC\-(1|2|3|7)(\.[a-z]{1})?(\.\d+)?/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], number: ['7'], sub_fam: ['a'])
    expect(filter.to_s).to eq 'AC-7.a'
    expect(filter.regex).to eq(/\bAC\-7\.a(\.\d+)?/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], number: ['7'], sub_fam: %w{a b})
    expect(filter.to_s).to eq 'AC-7.[a, b]'
    expect(filter.regex).to eq(/\bAC\-7\.(a|b)(\.\d+)?/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], number: ['7'], sub_fam: ['a'], sub_num: ['1'])
    expect(filter.to_s).to eq 'AC-7.a.1'
    expect(filter.regex).to eq(/\bAC\-7\.a\.1/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], number: ['7'], sub_fam: ['a'], sub_num: %w{1 2})
    expect(filter.to_s).to eq 'AC-7.a.[1, 2]'
    expect(filter.regex).to eq(/\bAC\-7\.a\.(1|2)/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], enhancement: ['2'])
    expect(filter.to_s).to eq 'AC-*([2])'
    expect(filter.regex).to eq(/\bAC\-\d+(\.[a-z]{1})?(\.\d+)?\(2\)(\.[a-z]{1}(\.\d+)?)?\Z/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], enhancement: ['none'])
    expect(filter.to_s).to eq 'AC-*Z'
    expect(filter.regex).to eq(/\bAC\-\d+(\.[a-z]{1})?(\.\d+)?\Z/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], enhancement: %w{2 3})
    expect(filter.to_s).to eq 'AC-*([2, 3])'
    expect(filter.regex).to eq(/\bAC\-\d+(\.[a-z]{1})?(\.\d+)?\((2|3)\)(\.[a-z]{1}(\.\d+)?)?\Z/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], enhancement: ['2'], enh_sub_fam: ['a'])
    expect(filter.to_s).to eq 'AC-*([2]).a'
    expect(filter.regex).to eq(/\bAC\-\d+(\.[a-z]{1})?(\.\d+)?\(2\)\.a(\.\d+)?\Z/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], enhancement: ['2'], enh_sub_fam: %w{a b})
    expect(filter.to_s).to eq 'AC-*([2]).[a, b]'
    expect(filter.regex).to eq(/\bAC\-\d+(\.[a-z]{1})?(\.\d+)?\(2\)\.(a|b)(\.\d+)?\Z/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], enhancement: ['2'], enh_sub_fam: ['a'], enh_sub_num: ['1'])
    expect(filter.to_s).to eq 'AC-*([2]).a.1'
    expect(filter.regex).to eq(/\bAC\-\d+(\.[a-z]{1})?(\.\d+)?\(2\)\.a\.1\Z/)
  end

  it 'creates a regex' do
    filter = Filter.new(family: ['AC'], enhancement: ['2'], enh_sub_fam: ['a'], enh_sub_num: %w{1 2})
    expect(filter.to_s).to eq 'AC-*([2]).a.[1, 2]'
    expect(filter.regex).to eq(/\bAC\-\d+(\.[a-z]{1})?(\.\d+)?\(2\)\.a\.(1|2)\Z/)
  end
end
