# frozen_string_literal: true

require './example'
require 'timecop'

describe MyBankOpeningHours do
  subject { described_class.new }

  describe '<=>' do
    after { Timecop.return }

    context 'when comparing to a not Time like object' do
      it 'raises an error' do
        expect { subject > Date.today }.to raise_exception(ArgumentError, /with Date failed/)
      end
    end

    context 'before it opens' do
      it 'works as expected' do
        Timecop.freeze('7:59')

        expect(subject > Time.now).to eq(true)
        expect(subject == Time.now).to eq(false)
        expect(subject < Time.now).to eq(false)
      end
    end

    context 'when it is open' do
      it 'works as expected' do
        Timecop.freeze('8:00')

        expect(subject > Time.now).to eq(false)
        expect(subject == Time.now).to eq(true)
        expect(subject < Time.now).to eq(false)
      end
    end

    context 'after it closes' do
      it 'works as expected' do
        Timecop.freeze('17:41')

        expect(subject > Time.now).to eq(false)
        expect(subject == Time.now).to eq(false)
        expect(subject < Time.now).to eq(true)
      end
    end
  end
end
