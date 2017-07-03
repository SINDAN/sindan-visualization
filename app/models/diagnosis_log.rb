# coding: utf-8
class DiagnosisLog < ApplicationRecord
  belongs_to :log_campaign, foreign_key: :log_campaign_uuid, primary_key: :log_campaign_uuid

  enum result: {
         fail: 0,
         success: 1,
         information: 10,
       }

  cattr_reader :layer_defs
  @@layer_defs = {
    datalink: 'データリンク層',
    interface: 'インタフェース設定層',
    localnet: 'ローカルネットワーク層',
    globalnet: 'グローバルネットワーク層',
    dns: '名前解決層',
    web: 'ウェブアプリケーション層',
  }

  default_scope { order(occurred_at: :desc) }

  scope :log, lambda {
    condition = arel_table[:result].eq(DiagnosisLog.results[:fail])
                .or(arel_table[:result].eq(DiagnosisLog.results[:success]))
    where(condition)
  }
  scope :occurred_before, ->(time) { where("occurred_at < ?", time) }
  scope :occurred_after, ->(time) { where("occurred_at > ?", time) }
  scope :layer_by, ->(layer) { where(layer: layer) }

  def self.layer_label(layer)
    if !layer.blank? && self.layer_defs.keys.include?(layer.to_sym)
      self.layer_defs[layer.to_sym]
    else
      layer
    end
  end

  def layer_label
    DiagnosisLog.layer_label(self.layer)
  end

  def result_label
    unless self.result.nil?
      self.result
    end
  end

  def log
    "#{self.layer_label}(#{self.log_group}) #{self.log_type}<br />#{self.detail}"
  end

  def self.date_list
    Rails.cache.fetch("date_list") do
      DiagnosisLog.pluck(:occurred_at).map{ |occurred_at| occurred_at.to_date.to_s unless occurred_at.blank? }.uniq
    end
  end

  # for ransacker
  ransacker :occurred_at do
    Arel.sql('date(occurred_at)')
  end
end
