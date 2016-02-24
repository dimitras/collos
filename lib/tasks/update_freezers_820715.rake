namespace :db do
	require 'rubygems'
	require 'csv'

	# USAGE: rake db:update_freezers --trace
	desc "update freezers"
	task :update_freezers  => :environment do

		samples_file = "workspace/data/KT_820715/change_freezers.csv"
		CSV.foreach(samples_file) do |row|
			boxname = row[1]
			freezer_label = row[2]

			box = Container.find_by_name(boxname)
			freezer = Container.find_by_name(freezer_label)
			if box
				p box.name
				#Container.update(box.id, {:parent => freezer})
			end
		end
	end
end
