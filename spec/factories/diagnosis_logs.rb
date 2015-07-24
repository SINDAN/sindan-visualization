FactoryGirl.define do
  factory :diagnosis_log do
    layer "MyText"
    log_type "MyText"
    result true
    detail "MyText"
    occurred_at "2015-07-24 19:24:42"
  end

end
