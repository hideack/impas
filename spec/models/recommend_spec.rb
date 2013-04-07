require 'spec_helper'

describe "Recommend Model" do
  let(:recommend) { Recommend.new }
  it 'can be created' do
    recommend.should_not be_nil
  end
end
