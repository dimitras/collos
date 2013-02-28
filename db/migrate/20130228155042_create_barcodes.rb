class CreateBarcodes < ActiveRecord::Migration
  def change
    create_table(:barcodes) do |t|
      t.string  :barcode
      t.integer :barcode_set, default: 0
    end
    add_index :barcodes, :barcode_set
    add_index :barcodes, :barcode, unique: true
  end
end
