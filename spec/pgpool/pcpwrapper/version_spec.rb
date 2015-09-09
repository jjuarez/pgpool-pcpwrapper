require 'spec_helper'

describe PGPool::PCPWrapper do
  it 'has a version number' do
    expect(PGPool::PCPWrapper::VERSION).not_to be nil
  end

  it 'has a semantic version number' do
    major, minor, patch = PGPool::PCPWrapper::VERSION.split('.').map(&:to_i)

    expect(major.class).to be Fixnum
    expect(minor.class).to be Fixnum
    expect(patch.class).to be Fixnum
  end
end
