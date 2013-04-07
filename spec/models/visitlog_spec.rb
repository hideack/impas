require 'spec_helper'

describe "Visitlog Model" do
  let(:visitlog) { Visitlog.new }
  it 'can be created' do
    visitlog.should_not be_nil
  end
end
