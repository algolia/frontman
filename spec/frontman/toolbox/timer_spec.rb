# typed: false
# frozen_string_literal: true

require './spec/spec_setup'
require 'frontman/toolbox/timer'

describe Frontman::Toolbox::Timer do
  it 'should create and start a timer' do
    timer = Frontman::Toolbox::Timer.start
    expect(timer).to be_a Frontman::Toolbox::Timer
    expect(timer.started_at).to_not eq nil
    expect(timer.ended_at).to eq nil
  end

  it 'should set the stop time correctly' do
    timer = Frontman::Toolbox::Timer.start
    timer.stop
    expect(timer.ended_at).to_not eq nil
  end

  it 'should calculate the correct difference' do
    timer = Frontman::Toolbox::Timer.new
    start_time = timer.begin
    end_time = timer.stop
    expect(timer.diff).to eq(end_time - start_time)
  end

  it 'should show the correct output' do
    timer = Frontman::Toolbox::Timer.new
    start_time = timer.begin
    end_time = timer.stop
    expect(timer.output).to eq "Elapsed time: #{(end_time - start_time) * 1000} milliseconds.\n"
  end
end
