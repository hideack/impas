require 'spec_helper'

describe "Crawlelist Model" do
  let(:crawlelist) { Crawlelist.new }
  it 'can be created' do
    crawlelist.should_not be_nil
  end
end
