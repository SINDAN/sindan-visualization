class RenameLogUnitUuidColumnToDiagnosisLogs < ActiveRecord::Migration
  def change
    rename_column :diagnosis_logs, :log_unit_uuid, :log_campaign_uuid
  end
end
