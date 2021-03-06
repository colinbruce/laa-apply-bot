require 'spec_helper'
require 'rack/test'

describe 'Sinatra App' do
  include Rack::Test::Methods

  def app
    App.new
  end

  it 'displays home page' do
    get '/'
    expect(last_response.body).to include('LAA-Apply bot')
  end

  describe '#ping' do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('BUILD_DATE').and_return(build_date)
      allow(ENV).to receive(:[]).with('BUILD_TAG').and_return(build_tag)
      get '/ping'
    end
    let(:build_date) { nil }
    let(:build_tag) { nil }

    context 'when environment variables set' do
      let(:build_date) { '20150721' }
      let(:build_tag) { 'test' }

      let(:expected_json) do
        {
          'build_date' => '20150721',
          'build_tag' => 'test'
        }
      end

      it 'returns JSON with app information' do
        expect(JSON.parse(last_response.body)).to eq(expected_json)
      end
    end

    context 'when environment variables not set' do
      it 'returns "Not Available"' do
        expect(JSON.parse(last_response.body).values).to be_all('Not Available')
      end
    end

    it 'returns ok http status' do
      expect(last_response.status).to eq 200
    end
  end
end
