require 'spec_helper'
require 'pgpool/version'

describe PGPool do
  it 'has a version number' do
    expect(PGPool::VERSION).not_to be nil
  end

  it 'has a semantic version number' do
    major, minor, patch = PGPool::VERSION.split('.').map(&:to_i)

    expect(major.class).to be Fixnum
    expect(minor.class).to be Fixnum
    expect(patch.class).to be Fixnum
  end
end
