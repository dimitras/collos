object @barcode

attributes :barcode, :barcode_set

# child :barcodeable do
#     attributes :id, :name
#     node(:url) do |barcodeable|
#         if barcodeable.kind_of? Sample
#             sample_url(barcodeable)
#         else
#             container_url(barcodeable)
#         end
#     end
# end
