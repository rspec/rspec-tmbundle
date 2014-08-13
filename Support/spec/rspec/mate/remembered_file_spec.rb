require 'spec_helper'
require 'rspec/mate/remembered_file'

describe RSpec::Mate::RememberedFile do
  before { described_class.clear }

  it 'can #save and #load a path' do
    expect(described_class.load).to eq(nil)
    path = 'some path'
    described_class.save(path)
    expect(described_class.load).to eq(path)
  end
end
