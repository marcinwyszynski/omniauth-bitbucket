require 'spec_helper'

describe OmniAuth::Strategies::Bitbucket do
  context "email" do
    let(:email) { "#{("a".."z").to_a.sample(6).join}@example.com" }
    let(:strategy) { OmniAuth::Strategies::Bitbucket.new nil }
    
    it 'should fall back to non-primary' do
      strategy.stub_chain(:access_token, :get) do |url|
        body = url =~ /emails$/ ? %{{"pagelen": 10, "values": [{"is_primary": true, "is_confirmed": true, "type": "email", "email": "#{email}", "links": {"self": {"href": "https://bitbucket.org/!api/2.0/user/emails/#{email}"}}}], "page": 1, "size": 1}} : '{"user": {}}'
        double body: body
      end
      strategy.raw_info['email'].should == email
    end
  
    it "should prefer primary" do
      strategy.stub_chain(:access_token, :get) do |url|
        body = url =~ /emails$/ ? %{{"pagelen": 10, "values": [{"is_primary": true, "is_confirmed": true, "type": "email", "email": "#{email}", "links": {"self": {"href": "https://bitbucket.org/!api/2.0/user/emails/#{email}"}}}], "page": 1, "size": 1}} : '{"user": {}}'
        double body: body
      end
      strategy.raw_info['email'].should == email
    end
    
    it "should ignore non-existing" do
      strategy.stub_chain(:access_token, :get) do |url|
        body = url =~ /emails$/ ? %{{"pagelen": 0, "values": []}} : '{"user": {}}'
        double body: body
      end
      strategy.raw_info['email'].should be_nil
    end
  end
end
