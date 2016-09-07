# coding: utf-8
require 'rails_helper'

RSpec.describe DiagnosisLog, type: :model do
  before(:each) do
    @diagnosis_log = DiagnosisLog.new()
  end

  it "is valid with valid attributes" do
    expect(@diagnosis_log).to be_valid
  end

  it "is not valid with invalid value of result" do
    pending "invalid value occored other exception"

    @diagnosis_log.result = :invalid

    expect(@diagnosis_log).not_to be_valid
  end

  context "scope log" do
    before(:each) do
      FactoryGirl.create(:diagnosis_log, result: 'success')
      FactoryGirl.create(:diagnosis_log, result: 'fail')
      FactoryGirl.create(:diagnosis_log, result: 'information')

      @diagnosis_logs = DiagnosisLog.log
    end

    it "not include error" do
      expect(@diagnosis_logs.count).to eq 2
    end
  end

  context "scope error" do
    before(:each) do
      FactoryGirl.create(:diagnosis_log, result: 'success')
      FactoryGirl.create(:diagnosis_log, result: 'fail')
      FactoryGirl.create(:diagnosis_log, result: 'information')

      @diagnosis_logs = DiagnosisLog.fail
    end

    it "only include error " do
      expect(@diagnosis_logs.count).to eq 1
    end
  end

  context "Layer label" do
    before(:each) do
      @diagnosis_log = DiagnosisLog.new(
        layer: :web
      )
    end

    it "replace label with value of layer" do
      @diagnosis_log.layer = :web

      expect(@diagnosis_log.layer_label).to eq("ウェブアプリケーション層")
    end

    it "is not plane value with value of layer" do
      @diagnosis_log.layer = :web

      expect(@diagnosis_log.layer_label).not_to eq("web")
    end

    it "not replace label with invalid value of layer" do
      @diagnosis_log.layer = :invalid

      expect(@diagnosis_log.layer_label).to eq("invalid")
    end
  end

  context "Layer label for args" do
    it "replace label with value of layer" do
      layer_label = DiagnosisLog.layer_label('web')

      expect(layer_label).to eq("ウェブアプリケーション層")
    end

    it "is not plane value with value of layer" do
      layer_label = DiagnosisLog.layer_label('web')

      expect(layer_label).not_to eq("web")
    end

    it "not replace label with invalid value of layer" do
      layer_label = DiagnosisLog.layer_label('invalid')

      expect(layer_label).to eq("invalid")
    end
  end
end
