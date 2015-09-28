class AddIndexToDiagnosisLog < ActiveRecord::Migration
  def change
    add_index :diagnosis_logs, :occurred_at
  end
end
