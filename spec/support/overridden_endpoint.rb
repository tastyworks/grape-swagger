# frozen_string_literal: true

RSpec.shared_examples 'overridden endpoint' do
  context 'api documentation' do
    subject do
      get '/swagger_doc'
      JSON.parse(last_response.body)['paths']['/']['get']
    end

    it 'shows documentation from new endpoint' do
      expect(subject['parameters'][0]['description']).to eql('new param')
      expect(subject['parameters'][0]['type']).to eql('string')
      expect(subject['responses']['200']['description']).to eql('new message')
    end
  end

  context 'api response' do
    subject { get '/' }

    it 'returns new response' do
      expect(subject.body).to eql('new')
    end
  end
end
