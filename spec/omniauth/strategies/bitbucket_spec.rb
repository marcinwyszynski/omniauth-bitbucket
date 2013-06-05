require 'spec_helper'

describe OmniAuth::Strategies::Bitbucket do
  context "email" do
    let(:email) { "#{("a".."z").to_a.sample(6).join}@example.com" }
    let(:strategy) { OmniAuth::Strategies::Bitbucket.new nil }
    
    it 'should fall back to non-primary' do
      strategy.stub_chain(:access_token, :get) do |url|
        body = url =~ /emails$/ ? %{[{"active": true, "email": "#{email}", "primary": false}]} : '{"user": {}}'
        double body: body
      end
      strategy.raw_info['email'].should == email
    end
  
    it "should prefer primary" do
      strategy.stub_chain(:access_token, :get) do |url|
        body = url =~ /emails$/ ? %{[{"active": true, "email": "someemail@example.com", "primary": false}, {"active": true, "email": "#{email}", "primary": true}]} : '{"user": {}}'
        double body: body
      end
      strategy.raw_info['email'].should == email
    end
    
    it "should ignore non-existing" do
      strategy.stub_chain(:access_token, :get) do |url|
        body = url =~ /emails$/ ? %{[]} : '{"user": {}}'
        double body: body
      end
      strategy.raw_info['email'].should be_nil
    end
  end
end
