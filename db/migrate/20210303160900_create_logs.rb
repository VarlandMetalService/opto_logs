class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.string    :type,            null: false
      t.string    :controller_name, null: false
      t.datetime  :log_at,          null: false
      t.integer   :lane,            null: true,   default: nil
      t.integer   :station,         null: true,   default: nil
      t.integer   :shop_order,      null: true,   default: nil
      t.integer   :load,            null: true,   default: nil
      t.integer   :barrel,          null: true,   default: nil
      t.string    :customer,        null: true,   default: nil
      t.string    :process,         null: true,   default: nil
      t.string    :part,            null: true,   default: nil
      t.string    :sub,             null: true,   default: nil
      t.float     :reading,         null: true,   default: nil
      t.float     :limit,           null: true,   default: nil
      t.float     :low_limit,       null: true,   default: nil
      t.float     :high_limit,      null: true,   default: nil
      t.text      :json_data,       null: false
      t.timestamps
    end
  end
end