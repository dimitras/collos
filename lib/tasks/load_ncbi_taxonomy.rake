namespace :ncbi_taxonomy do

  desc "Downloads the NCBI taxonomy from the interwebz"
  task :download do 
    unless File.exists? "#{Rails.root}/tmp/taxdmp.zip"
      system("wget -O #{Rails.root}/tmp/taxdmp.zip ftp://anonymous@ftp.ncbi.nih.gov/pub/taxonomy/taxdmp.zip")
      system("unzip -d #{Rails.root}/tmp/ncbi #{Rails.root}/tmp/taxdmp.zip")
    end
  end

  desc "Loads the NCBI taxonomy into the DB"
  task :load => :download do 
    # load the nodes.dmp table
    nodes={}
    File.open("#{Rails.root}/tmp/ncbi/nodes.dmp").each do |l|
      entry = l.chomp.split(/\|/).map {|x| x.strip }
      Taxon.create!(ncbi_id: e[0], parent_ncbi_id: e[1], rank: e[2])
      # assign the parent 
    end      
  end

end
