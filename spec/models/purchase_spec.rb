require 'spec_helper'

describe Purchase do
  before { @purchase = FactoryGirl.build(:purchase) }

  subject { @purchase }

  it { should respond_to(:deal) }
end
