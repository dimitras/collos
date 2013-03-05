namespace :ncbi_taxonomy do

  desc "Downloads the NCBI taxonomy from the interwebz"
  task :download do 
    unless File.exists? "#{Rails.root}/tmp/taxdmp.zip"
      system("wget -O #{Rails.root}/tmp/taxdmp.zip ftp://anonymous@ftp.ncbi.nih.gov/pub/taxonomy/taxdmp.zip")
      system("unzip -d #{Rails.root}/tmp/ncbi #{Rails.root}/tmp/taxdmp.zip")
    end
  end

  desc "Loads the NCBI taxonomy into the DB"
  task :load => [:environment, :download] do 
    # load the nodes.dmp table
    cols = "(ncbi_id,parent_ncbi_id,rank)"
    count = 0
    records = []
    puts "Inserting Taxon nodes"
    File.open("#{Rails.root}/tmp/ncbi/nodes.dmp").each do |l|
      if count < 1000
        e = l.chomp.split(/\|/).map {|x| x.strip }
        records << "(#{e[0]},#{e[1]},#{e[2]})"
      else
        Taxon.sql("INSERT INTO taxons #{cols} VALUES #{records.join(',')}")
        records = []
        count = 0
      end
    end
    Taxon.sql("INSERT INTO taxons #{cols} VALUES #{records.join(',')}")
    records = []
    count = 0
    puts "Updating Taxon ancestry"
    Taxon.find_each(batch_size: 1000) do |t|
      t.parent = Taxon.where(ncbi_id: t.parent_ncbi_id).first
      t.save
      taxa[t.ncbi_id] = t.id
    end
    puts "Inserting TaxonName nodes"
    cols = "(taxon_id,name,uniq_name,name_class)"
    count = 0
    records = []
    File.open("#{Rails.root}/tmp/ncbi/names.dmp").each do |l|
      if count < 1000
        e = l.chomp.split(/\|/).map {|x| x.strip }
        records << "(#{taxa[e[0]]},#{e[1]},#{e[2]},#{e[3]})"
      else
        TaxonName.sql("INSERT INTO taxon_names #{cols} VALUES #{records.join(',')}")
        records = []
        count = 0
      end
    end
    TaxonName.sql("INSERT INTO taxons #{cols} VALUES #{records.join(',')}")
  end
end
