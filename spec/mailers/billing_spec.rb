
describe Billing do
  describe "GET #billing" do
    it "sends invoice" do
      member = FactoryGirl.build(:member)
      Member.stub(:find).and_return(member)
      FactoryGirl.create(:membergroup)
      yla = "ddd"
      ala = "jee"
      Billing.bill_email(member, yla, ala).should be_true
    end
    it "sends remainder" do
      member = FactoryGirl.build(:member)
      Member.stub(:find).and_return(member)
      FactoryGirl.create(:membergroup)
      viesti = "joo"
      otsikko = "topic"
      Billing.reminder_email(member, viesti, otsikko).should be_true
    end
    it "sends mail" do
      member = FactoryGirl.build(:member)
      Member.stub(:find).and_return(member)
      viesti = "joo"
      otsikko = "topic"
      Billing.mailer(member, viesti, otsikko).should be_true
    end
  end
end