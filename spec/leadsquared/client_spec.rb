require 'spec_helper'

describe Leadsquared do
  let(:client) { Leadsquared::Client.new('token', 'pass', 'http://localhost:8088/mock') }

  describe "Valid Request" do
    let(:service) { "service1" }
    let(:body) do
      {key1: 'value1', key2: 'value2'}
    end
    let(:auth_params) { "?accessKey=token&secretKey=pass" }

    it "#post" do
      blk = lambda do |req|
        expect(req.body).to  match(body)
      end
      stub_request(:post, "http://localhost:8088/mock/#{service}#{auth_params}").with(&blk).
        to_return(status: 200, body: "{\"id\": \"123456\"}")
      response = client.post(service, {}, body)
      expect(response.status).to eql(200)
    end

    it "#get" do
      params = {xid: '1'}
      stub_request(:get, "http://localhost:8088/mock/#{service}#{auth_params}&xid=1").
        to_return(status: 200, body: body.to_json)
      response = client.get(service, params)
      expect(response.status).to eql(200)

    end
  end

  describe "Configuration" do
    it "requires token and secret" do
      expect { Leadsquared::Client.new }.to raise_error(ArgumentError)
    end

    describe "preset" do
      before do
        Leadsquared.configure do |config|
          config.key      = 'mylogin'
          config.secret   = 'mypassword'
          config.endpoint = "http://google.com"
        end
      end

      after do
        Leadsquared.configure do |config|
          config.key      = nil
          config.secret   = nil
          config.endpoint = Leadsquared::Client::ENDPOINT
        end
      end

      it "configures the client" do
        Leadsquared.configure do |config|
          config.key      = 'mylogin'
          config.secret   = 'mypassword'
          config.endpoint = "http://google.com"
        end
        client = Leadsquared::Client.new
        expect(client.key).to eq('mylogin')
        expect(client.secret).to eq('mypassword')
        expect(client.endpoint).to eq("http://google.com")
      end
    end
  end
end
