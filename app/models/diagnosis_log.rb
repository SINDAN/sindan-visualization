# coding: utf-8
class DiagnosisLog < ActiveRecord::Base
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

  def layer_label
    if !self.layer.blank? && self.layer_defs.keys.include?(self.layer.to_sym)
      self.layer_defs[self.layer.to_sym]
    else
      self.layer
    end
  end

  def result_label
    unless self.result.nil?
      self.result
    end
  end

  # for ransacker
  ransacker :occurred_at do
    Arel.sql('date(occurred_at)')
  end
end
