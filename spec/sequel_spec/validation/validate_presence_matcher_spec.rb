require 'spec_helper'

describe "validate_presence_matcher" do
  before :all do
    define_model :item do
      plugin :validation_helpers

      def validate
        validates_presence [:id, :name], :allow_nil => true
      end
    end
  end

  subject{ Item }

  it "should require an attribute" do
    expect {
      subject.should validate_presence
    }.to raise_error(ArgumentError)
  end

  it "should accept with an attribute" do
    expect {
      subject.should validate_presence(:name)
    }.not_to raise_error
  end

  it "should accept with valid options" do
    expect {
      subject.should validate_presence(:name).allowing_nil
    }.not_to raise_error
  end

  it "should reject with invalid options" do
    expect {
      subject.should validate_presence(:name).allowing_blank
    }.to raise_error
  end

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = validate_presence :name
        @matcher.description.should == "validate presence of :name"
      end

      it "should set failure messages" do
        @matcher = validate_presence :name
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end

    describe "with options" do
      it "should contain a description" do
        @matcher = validate_presence(:name).allowing_nil
        @matcher.description.should == "validate presence of :name with option(s) :allow_nil => true"
      end

      it "should set failure messages" do
        @matcher = validate_presence(:price).allowing_nil
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = validate_presence(:name).allowing_blank
        @matcher.matches? subject
        explanation = " but called with option(s) :allow_nil => true instead"
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end
end
