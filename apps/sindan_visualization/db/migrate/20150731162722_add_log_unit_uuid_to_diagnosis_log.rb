class AddLogUnitUuidToDiagnosisLog < ActiveRecord::Migration
  def change
    add_column :diagnosis_logs, :log_unit_uuid, :string, limit: 38
    add_index :diagnosis_logs, :log_unit_uuid
  end
end
