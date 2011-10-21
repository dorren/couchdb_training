FactoryGirl.define do
  factory :article do
    sequence(:id) {|n| %(doc_#{"%02d" % n}) }
    title    'Default Title'
    content  'na'
  end
end
