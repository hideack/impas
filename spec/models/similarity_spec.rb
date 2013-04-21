require 'spec_helper'

describe "Similarity Model" do
  let(:similarity) { Similarity.new }
  it 'can be created' do
    similarity.should_not be_nil
  end
end
