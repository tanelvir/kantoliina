require 'faker'

FactoryGirl.define do
  factory :member do |f|
    f.id "1"
    f.firstnames "John"
    f.surname "Doe"
    f.municipality "f"
    f.zipcode "00540"
    f.address "Street 7"
    f.postoffice "Helsinki"
    f.country "Suomi"
    f.email "sadasdsa@com.cocm"
    f.membergroup_id "1"
    f.membernumber "33333"
    f.membershipyear "2014"
    f.paymentstatus "f"
    f.invoicedate "08/08/2013"
    f.reminderdate "09/08/2013"
    f.paymentdate "08/08/2013"
    f.active "t"
    f.lender "f"
    f.support "f"
    f.info "joo"


  end
  factory :invalid_member, parent: :member  do |f|
    f.name nil
  end

end

