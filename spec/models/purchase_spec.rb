require 'spec_helper'

describe Purchase do
  before { @purchase = FactoryGirl.build(:purchase) }

  subject { @purchase }

  it { should respond_to(:deal) }

  describe "when not attached to a deal" do
    it { should_not be_valid }
  end

  describe "when attached to a deal" do
    before do
      deal = FactoryGirl.create(:deal)
      @purchase.deal = deal
    end

    it { should be_valid }
  end
end
