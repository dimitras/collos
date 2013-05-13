class CreateBarcodes < ActiveRecord::Migration
  def change
    create_table(:barcodes) do |t|
      t.string  :barcode
      t.integer :barcode_set, default: 0
      t.references  :barcodeable, polymorphic: true
    end
    add_index :barcodes, :barcode_set
    add_index :barcodes, :barcode, unique: true
    add_index :barcodes, [:barcodeable_type,:barcodeable_id]
  end
end
