require 'spec_helper'

describe 'Storj::Authorization_token' do
  describe 'accepted values' do
    [
      'a@a.ab:ab',
      'test.test@test.test:test',
      'test.test@test.test:TEST',
      'test.test@test.test:T3sT',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'rejects other values' do
    [
      '',
      'a',
      '123',
      3,
      true,
      nil,
      'a.a@a.ab:&',
      'a.a@a.ab:$',
      'a.a@a.ab:-',
      'a.a@a.ab:_',
      'a.a@a.ab:=',
      'a.a@a.ab:+',
      'a.a@a.ab:.',
      'a.a@a.ab:/',
      'a.a@a.ab:!',
      'a.a@a.ab:@',
      'a.a@a.ab:#',
      'a.a@a.ab:%',
      'a.a@a.ab:^',
      'a.a@a.ab:*',
      'a.a@a.ab:(',
      'a.a@a.ab:)',
      'a.a@a.ab:<',
      'a.a@a.ab:>',
      'a.a@a.ab:,',
      'a.a@a.ab:\\',
      'a.a@a.ab:',
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
