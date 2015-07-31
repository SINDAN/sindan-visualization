class AddLogGroupToDiagnosisLog < ActiveRecord::Migration
  def change
    add_column :diagnosis_logs, :log_group, :string
  end
end
