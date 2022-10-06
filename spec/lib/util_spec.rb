# frozen_string_literal: true

require 'pry'
require 'spec_helper'

RSpec.describe GrapeSwagger::Rake::Util do
  describe '#swagger_doc_url_data_for' do
    let(:result) { described_class.swagger_doc_url_data_for(api_class) }

    context 'with path versioning' do
      let(:api_class) { Api::Base }

      it 'generates correct data' do
        expect(result).to eq([
          {
            path: '/api/swagger_doc',
            api_version: '',
            file_path: File.join(Dir.getwd, 'swagger_doc.json')
          }
        ])
      end
    end

    context 'with docs nested under version url' do
      let(:api_class) { NestedVersionApi::Base }

      it 'generates correct data' do
        expect(result).to eq([
          {
            path: '/api/v1/swagger_doc',
            api_version: 'v1',
            file_path: File.join(Dir.getwd, 'swagger_doc_v1.json')
          },
          {
            path: '/api/v2/swagger_doc',
            api_version: 'v2',
            file_path: File.join(Dir.getwd, 'swagger_doc_v2.json')
          }
        ])
      end
    end

    context 'with header versioning' do
      let(:api_class) { HeaderVersionedApi::Base }

      it 'generates correct data' do
        expect(result).to eq([
          {
            path: '/api/swagger_doc',
            api_version: 'v1',
            file_path: File.join(Dir.getwd, 'swagger_doc_v1.json')
          },
          {
            path: '/api/swagger_doc',
            api_version: 'v2',
            file_path: File.join(Dir.getwd, 'swagger_doc_v2.json')
          }
        ])
      end
    end
  end

  describe '#file_path' do
    let(:api_version) { 'v1' }
    let(:store) { nil }
    let(:result) { File.basename(described_class.file_path(api_version)) }

    before do
      allow(ENV).to receive(:fetch).with('store', nil).and_return(store)
    end

    shared_examples 'swagger file name' do |expected_name|
      it 'returns correct file name' do
        expect(result).to eq expected_name
      end
    end

    describe 'no store given' do
      let(:store) { nil }

      it_behaves_like 'swagger file name', 'swagger_doc_v1.json'

      context 'with no api_version' do
        let(:api_version) { nil }

        it_behaves_like 'swagger file name', 'swagger_doc.json'
      end
    end

    describe 'store given' do
      describe 'boolean true' do
        let(:store) { 'true' }

        it_behaves_like 'swagger file name', 'swagger_doc_v1.json'

        context 'with no api_version' do
          let(:api_version) { nil }

          it_behaves_like 'swagger file name', 'swagger_doc.json'
        end
      end

      describe 'name given' do
        let(:store) { 'oapi_doc.json' }

        it_behaves_like 'swagger file name', 'oapi_doc_v1.json'

        context 'with no api_version' do
          let(:api_version) { nil }

          it_behaves_like 'swagger file name', 'oapi_doc.json'
        end
      end
    end
  end
end
