class CreateDiagnosisLogs < ActiveRecord::Migration
  def change
    create_table :diagnosis_logs do |t|
      t.string :case_name
      t.text :node_name
      t.string :ssid

      t.timestamps null: false
    end
  end
end
