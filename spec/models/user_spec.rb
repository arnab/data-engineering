require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end

  subject { @user }

  it { should be_valid }

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
