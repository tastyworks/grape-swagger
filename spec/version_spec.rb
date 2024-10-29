# frozen_string_literal: true

require 'spec_helper'

describe Tastyworks::GrapeSwagger do
  it '#version' do
    expect(Tastyworks::GrapeSwagger::VERSION).to_not be_nil
    expect(Tastyworks::GrapeSwagger::VERSION.split('.').count).to eq 3
  end
end
