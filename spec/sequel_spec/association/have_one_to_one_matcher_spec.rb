require 'spec_helper'

describe "have_one_to_one_matcher" do
  before :all do
    define_model :item do
      one_to_one :comment
    end
    define_model :comment
  end

  subject{ Item }

  describe "messages" do
    describe "without option" do
      it "should contain a description" do
        @matcher = have_one_to_one :comment
        @matcher.description.should == "have a one_to_one association :comment"
      end

      it "should set failure messages" do
        @matcher = have_one_to_one :comment
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end
    end

    describe "with options" do
      it "should contain a description" do
        @matcher = have_one_to_one(:comment).with_options :class_name => "Comment"
        @matcher.description.should == 'have a one_to_one association :comment with option(s) :class_name => "Comment"'
      end

      it "should set failure messages" do
        @matcher = have_one_to_one(:comment).with_options :class_name => "Comment"
        @matcher.matches? subject
        @matcher.failure_message.should == "expected Item to " + @matcher.description
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description
      end

      it "should explicit used options if different than expected" do
        @matcher = have_one_to_one(:comment).with_options :class_name => "Price"
        @matcher.matches? subject
        explanation = ' expected :class_name == "Price" but found "Comment" instead'
        @matcher.failure_message.should == "expected Item to " + @matcher.description + explanation
        @matcher.negative_failure_message.should == "expected Item to not " + @matcher.description + explanation
      end
    end
  end

  describe "matchers" do
    it{ should have_one_to_one(:comment) }
    it{ should have_one_to_one(:comment).with_options :class_name => "Comment" }
    it{ should_not have_one_to_one(:price) }
    it{ should_not have_one_to_one(:comment).with_options :class_name => "Price" }
  end
end
