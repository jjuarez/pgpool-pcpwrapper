require 'spec_helper'

describe PGPool::Wrapper do
  it 'has a version number' do
    expect(PGPool::Wrapper::VERSION).not_to be nil
  end

  it 'has a semantic version number' do
    major, minor, patch = PGPool::Wrapper::VERSION.split('.').map(&:to_i)

    expect(major.class).to be Fixnum
    expect(minor.class).to be Fixnum
    expect(patch.class).to be Fixnum
  end
end
