module Constants
  NIST_800_53 = JSON.parse(File.read("#{Rails.root}/data/nist_800_53.json"))
  hsh = {}
  NIST_800_53['children'].each do |cf|
    hsh[cf['name']] = cf['children'].size
  end
  NIST_800_53_COUNTS = hsh
end
