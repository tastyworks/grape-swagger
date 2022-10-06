# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GrapeSwagger::Rake::OapiTasks do
  subject { described_class.new(Api::Base) }

  let(:api_class) { subject.send(:api_class) }
  let(:docs_url_data) { GrapeSwagger::Rake::Util.swagger_doc_url_data_for(api_class).first }
  let(:docs_url) { docs_url_data[:path] }
  let(:resource) { nil }
  let(:store) { nil }

  before do
    allow(ENV).to receive(:fetch).with('resource', nil).and_return(resource)
    allow(ENV).to receive(:fetch).with('store', nil).and_return(store)
  end

  describe '.new' do
    it 'accepts class name as a constant' do
      expect(described_class.new(::Api::Base).send(:api_class)).to eq(Api::Base)
    end

    it 'accepts class name as a string' do
      expect(described_class.new('::Api::Base').send(:api_class)).to eq(Api::Base)
    end
  end

  describe '#make_request' do
    describe 'complete documentation' do
      before do
        subject.send(:make_request, docs_url)
      end

      describe 'not storing' do
        it 'has no error' do
          expect(subject.send(:error?)).to be false
        end

        it 'does not allow to save' do
          expect(subject.send(:save_to_file?)).to be false
        end

        it 'requests doc url' do
          expect(docs_url).to eql '/api/swagger_doc'
        end
      end

      describe 'store it' do
        let(:store) { 'true' }
        
        it 'allows to save' do
          expect(subject.send(:save_to_file?)).to be true
        end
      end
    end

    describe 'documentation for resource' do
      before do
        subject.send(:make_request, docs_url)
      end

      let(:response) do
        JSON.parse(
          subject.send(:make_request, docs_url)
        )
      end

      describe 'valid name' do
        let(:resource) { 'otherItem' }

        it 'has no error' do
          expect(subject.send(:error?)).to be false
        end

        it 'requests doc url' do
          expect(docs_url).to eql "/api/swagger_doc/#{resource}"
        end

        it 'has only one resource path' do
          expect(response['paths'].length).to eql 1
          expect(response['paths'].keys.first).to end_with resource
        end
      end

      describe 'wrong name' do
        let(:resource) { 'foo' }

        it 'has error' do
          expect(subject.send(:error?)).to be true
        end
      end

      describe 'empty name' do
        let(:resource) { nil }

        it 'has no error' do
          expect(subject.send(:error?)).to be false
        end

        it 'returns complete doc' do
          expect(response['paths'].length).to eql 2
        end
      end
    end

    describe 'call it' do
      before do
        subject.send(:make_request, docs_url)
      end
      specify do
        expect(subject).to respond_to :oapi
        expect(subject.oapi).to be_a String
        expect(subject.oapi).not_to be_empty
      end
    end
  end
end
