FactoryBot.define do
  factory :filter, class: Filter do
    family ['AC']
    number ['7']
    sub_fam ['a']
    sub_num ['1']
    enhancement ['4']
    enh_sub_fam ['a']
    enh_sub_num ['2']
  end

  factory :filter_simple, class: Filter do
    family ['AC']
    number []
    sub_fam []
    sub_num []
    enhancement []
    enh_sub_fam []
    enh_sub_num []
  end

  factory :filter_no_enh, class: Filter do
    family ['AC']
    number ['7']
    sub_fam ['a']
    sub_num ['1']
    enhancement ['none']
    enh_sub_fam []
    enh_sub_num []
  end
end
