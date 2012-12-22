require 'spec_helper'

describe "Url Model" do
  let(:url) { Url.new }
  it 'can be created' do
    url.should_not be_nil
  end
end
