require 'spec_helper'

# Most of the tests for this model are in cucumber. See the the cucumber steps for those.
# We are going to have some details specs for the class here.

describe DataFile do
  it_should_behave_like "ActiveModel"

  before { @data_file = FactoryGirl.build(:data_file) }

  subject { @data_file }

  it { should respond_to(:data) }
  it { should respond_to(:deals) }
  it { should respond_to(:purchases) }
  it { should respond_to(:allow_duplicate) }



  context "given invalid data" do
    before { @data_file = FactoryGirl.build(:data_file, :filename => "empty_file.txt") }
    it { should_not be_valid }
  end

  context "given valid data" do
    it { should be_valid }
  end

  describe "#header_converter" do
    describe "given a known header" do
      subject { @data_file.header_converter.call('purchase count') }
      it { should == :quantity }
    end

    describe "given a unknown header" do
      subject { @data_file.header_converter.call('foggy') }
      it { should == :foggy }
    end

    describe "given a nil header" do
      subject { lambda { @data_file.header_converter.call(nil) } }
      it { should raise_error }
    end

  end
end
